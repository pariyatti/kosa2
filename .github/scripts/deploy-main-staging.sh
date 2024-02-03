#!/bin/bash

# Define the directory
APP_DIR="/home/ec2-user/kosa2"

# Change to the app directory
cd "$APP_DIR"

# Check if the directory exists and is a Git repository
if [ -d ".git" ]; then
    echo "Updating Git repository in $APP_DIR"
    
    # Fetch the latest changes from the remote repository
    git fetch

    # Merge the fetched changes
    git merge

    echo "Repository updated successfully."
else
    echo "Error: The directory $APP_DIR is not a Git repository."
fi

echo "Updating docker-compose managed containers."
docker-compose -f docker-compose-staging.yml up --build -d
