locals {
  user_data = <<-EOT
    #!/bin/bash
    yum update -y
    yum upgrade -y
    systemctl enable amazon-ssm-agent
    systemctl start amazon-ssm-agent
    yum install -y amazon-efs-utils docker git tree
    file_system_id_01=fs-0be35ba21541d49a0
    efs_directory=/mnt/efs
    mkdir -p "$${efs_directory}"
    echo "$${file_system_id_01}:/ $${efs_directory} efs tls,_netdev" >> /etc/fstab
    mount -a -t efs defaults
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
      chmod 400 /home/ec2-user/.kosa/kosa-rails.dockerenv
      chown ec2-user:ec2-user /home/ec2-user/.kosa/kosa-rails.dockerenv
    fi
    su ec2-user -c 'ssh-keygen -F github.com || ssh-keyscan github.com >>/home/ec2-user/.ssh/known_hosts'
    su ec2-user -c 'cd /home/ec2-user && git clone git@github.com:pariyatti/kosa2.git'
    su ec2-user -c 'cd /home/ec2-user/kosa2 && ./bin/kosa-clone-txt-files.sh && ./init_server_container_env.sh'
    docker-compose -f /home/ec2-user/kosa2/docker-compose-staging.yml up -d
    TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`
    PUBLIC_IP=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/public-ipv4)
    aws route53 change-resource-record-sets --hosted-zone-id Z060531520ID78WZY53YW --change-batch '
    {
        "Changes": [
            {
                "Action": "UPSERT",
                "ResourceRecordSet": {
                    "Type": "A",
                    "Name": "kosa-staging.pariyatti.app",
                    "TTL": 60,
                    "ResourceRecords": [{"Value": "'$PUBLIC_IP'"}]
                }
            }
        ]
    }
    '
  EOT
  tags = {
    GithubRepo = "kosa2"
    GithubOrg  = "pariyatti"
  }
}


data "aws_vpc" "kosa2_vpc" {
  filter {
    name   = "tag:Name"
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
  owners      = ["amazon"]
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

data "aws_route53_zone" "kosa_domain" {
  name = "kosa-staging.pariyatti.app"
}

data "aws_security_group" "kosa_asg_sg" {
  tags = {
    Name = "kosa2-asg-sg"
  }
}

module "kosa2_asg" {
  source = "terraform-aws-modules/autoscaling/aws"

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
    AmazonSSMPatchAssociation    = "arn:aws:iam::aws:policy/AmazonSSMPatchAssociation"
    Kosa2DNSRecords              = aws_iam_policy.kosa2_set_dns.arn
    Kosa2S3Buckets               = aws_iam_policy.kosa2_s3_buckets.arn
  }

  capacity_reservation_specification = {
    capacity_reservation_preference = "open"
  }

  network_interfaces = [
    {
      delete_on_termination       = true
      description                 = "eth0"
      device_index                = 0
      security_groups             = [data.aws_security_group.kosa_asg_sg.id]
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

data "aws_iam_policy_document" "kosa2_set_dns" {
  statement {
    sid    = "SetDomainNames"
    effect = "Allow"

    actions = [
      "route53:ChangeResourceRecordSets"
    ]

    resources = [
      "arn:aws:route53:::hostedzone/${data.aws_route53_zone.kosa_domain.zone_id}"
    ]
  }
}

resource "aws_iam_policy" "kosa2_set_dns" {
  name   = "kosa2_set_dns_policy"
  path   = "/"
  policy = data.aws_iam_policy_document.kosa2_set_dns.json
}

data "aws_iam_policy_document" "kosa2_s3_buckets" {
  statement {
    sid    = "AllowBucketAccess"
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
      "s3:PutObject",
    ]

    resources = [
      "arn:aws:s3:::pariyatti-app-activestorage-staging",
      "arn:aws:s3:::pariyatti-app-activestorage-staging/*",
      "arn:aws:s3:::pariyatti-kosa2-postgresql-db-backup",
      "arn:aws:s3:::pariyatti-kosa2-postgresql-db-backup/*"
    ]
  }
}

resource "aws_iam_policy" "kosa2_s3_buckets" {
  name   = "kosa2_s3_buckets_access"
  path   = "/"
  policy = data.aws_iam_policy_document.kosa2_s3_buckets.json
}