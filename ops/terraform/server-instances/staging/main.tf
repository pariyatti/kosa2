locals {
  user_data = <<-EOT
    #!/bin/bash
    yum update -y
    yum upgrade -y
    systemctl enable amazon-ssm-agent
    systemctl start amazon-ssm-agent
    yum install -y docker git
    systemctl start docker
    systemctl enable docker
    usermod -aG docker ec2-user
    wget https://github.com/docker/compose/releases/download/v2.23.0/docker-compose-$(uname -s)-$(uname -m) -O /usr/bin/docker-compose
    chmod +x /usr/bin/docker-compose
    key_param=$(aws ssm get-parameter \
            --with-decryption \
            --name kosa-ssh-key \
            --output text \
            --query Parameter.Value)
    if [ $? -eq 0 ]; then
      mkdir -p /home/ec2-user/.ssh/
      echo "$${key_param}" > /home/ec2-user/.ssh/id_rsa
      chmod 400 /home/ec2-user/.ssh/id_rsa
      chown ec2-user:ec2-user /home/ec2-user/.ssh/id_rsa
    fi
    KOSA_RAILS_DOCKER_ENV=$(aws ssm get-parameter \
            --with-decryption \
            --name kosa-rails-docker-env \
            --output text \
            --query Parameter.Value)
    if [ $? -eq 0 ]; then
      mkdir -p /home/ec2-user/.kosa/
      echo "$${KOSA_RAILS_DOCKER_ENV}" >  /home/ec2-user/.kosa/kosa-rails.dockerenv
    fi
    git clone git@github.com:pariyatti/kosa2.git
    cd kosa2 && ./bin/kosa-clone-txt-files.sh
    docker-compose -f docker-compose-server.yml up -d
  EOT
  tags = {
    GithubRepo = "kosa2"
    GithubOrg  = "pariyatti"
  }
}


data "aws_vpc" "kosa2_vpc" {
   filter {
        name = "tag:Name"
        values = ["kosa2-vpc"]
    }
}


data "aws_subnets" "kosa2_public" {
  filter {
    name   = "tag:Name"
    values = ["kosa2-vpc-public-us-east-1a", "kosa2-vpc-public-us-east-1b", "kosa2-vpc-public-us-east-1c"]
  }
}

data "aws_ami" "amazonlinux_2023" {
  most_recent = true
  owners = [ "amazon" ]
  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
 
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
 
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

module "kosa_asg_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = "kosa2-asg-sg"
  description = "Kosa2 security group"
  vpc_id      = data.aws_vpc.kosa2_vpc.id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["https-443-tcp"]

  egress_rules = ["all-all"]

  tags = local.tags
}

module "kosa2_asg" {
  source  = "terraform-aws-modules/autoscaling/aws"

  # Autoscaling group
  name = "kosa2-asg"

  min_size                  = 0
  max_size                  = 1
  desired_capacity          = 1
  wait_for_capacity_timeout = 0
  health_check_type         = "EC2"
  vpc_zone_identifier       = toset(data.aws_subnets.kosa2_public.ids)

  initial_lifecycle_hooks = []

  instance_refresh = {
    strategy = "Rolling"
    preferences = {
      checkpoint_delay       = 600
      checkpoint_percentages = [35, 70, 100]
      instance_warmup        = 300
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }

  # Launch template
  launch_template_name        = "kosa2-asg"
  launch_template_description = "Kosa2 launch template test"
  update_default_version      = true

  image_id          = data.aws_ami.amazonlinux_2023.id
  instance_type     = "t3.medium"
  user_data         = base64encode(local.user_data)
  ebs_optimized     = true
  enable_monitoring = false

  # IAM role & instance profile
  create_iam_instance_profile = true
  iam_role_name               = "kosa2-asg"
  iam_role_path               = "/ec2/"
  iam_role_description        = "Kosa2 IAM role"
  iam_role_tags = {
    Purpose = "kosa2"
  }
  iam_role_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    AmazonSSMPatchAssociation = "arn:aws:iam::aws:policy/AmazonSSMPatchAssociation"
  }

  capacity_reservation_specification = {
    capacity_reservation_preference = "open"
  }

  network_interfaces = [
    {
      delete_on_termination = true
      description           = "eth0"
      device_index          = 0
      security_groups       = [module.kosa_asg_sg.security_group_id]
      associate_public_ip_address = true
    }
  ]

  tag_specifications = [
    {
      resource_type = "instance"
      tags          = { Purpose = "kosa2" }
    },
    {
      resource_type = "volume"
      tags          = { Purpose = "kosa2" }
    }
  ]

  tags = local.tags

}