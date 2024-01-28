#!/bin/bash

PASSWORD_FILE=".env.local_password"

# Check if the file exists
if [ ! -f "$PASSWORD_FILE" ]; then
  echo "Copying environment file from efs storage"
  cp /mnt/efs/volumes/db_env/$PASSWORD_FILE $PASSWORD_FILE
else
  echo "$PASSWORD_FILE already exists. Skipping password generation."
fi
