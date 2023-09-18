#!/bin/bash

PASSWORD_FILE=".env.local_password"

# Check if the file exists
if [ ! -f "$PASSWORD_FILE" ]; then
  # Generate a random password
  RANDOM_PASSWORD=$(openssl rand -base64 12)

  # Update the .env.local_password file with the generated password
  echo "POSTGRES_PASSWORD=${RANDOM_PASSWORD}" > "$PASSWORD_FILE"
  echo "KOSA2_DATABASE_PASSWORD=${RANDOM_PASSWORD}" >> .env.local_password

  echo "Generated a new password and saved it to $PASSWORD_FILE"
else
  echo "$PASSWORD_FILE already exists. Skipping password generation."
fi