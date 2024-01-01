#!/bin/bash

set -euxo pipefail

service_name="db"
database_name="kosa2_production"
date=$(date +%Y-%m-%d"_"%H_%M_%S)
backup_filename="${database_name}_${date}.sql"
backup_filename_zipped="${backup_filename}.gz"
s3_location="s3://pariyatti-kosa2-postgresql-db-backup/database/"

docker_bin=$(which docker)
aws_bin=$(which aws)

container_id=$(docker ps | grep $service_name | awk '{print $1}')

# create the backup
$docker_bin exec $container_id pg_dump -U kosa2 -f /tmp/$backup_filename $database_name

# copy file inside contaienr to host
$docker_bin cp $container_id:/tmp/$backup_filename .

# remove file in container
$docker_bin exec $container_id rm /tmp/$backup_filename

# compress
gzip $backup_filename

# upload to s3
$aws_bin s3 cp $backup_filename_zipped $s3_location

rm $backup_filename_zipped

echo "Backup completed. Filename: $backup_filename_zipped"