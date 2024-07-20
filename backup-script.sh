#!/bin/bash

time=$(date +%m-%d-%y_%H_%M_%S)
backup_file=/home/ubuntu/bash
dest=/home/ubuntu/backup
filename=file-backup-$time.tar.gz
LOG_FILE="/home/ubuntu/backup/logfile.log"
s3_bucket="updatedprojects234568"
FILE_TO_UPLODE="$dest/$filename"

# Check if aws CLI is installed
if ! command -v aws &> /dev/null; then
    echo "aws CLI is not installed yet. Please install it first."
    exit 2
fi

# Check if the destination directory exists
if [ ! -d "$dest" ]; then
    mkdir -p "$dest"
fi

# Check if the backup file already exists
if [ -f "$dest/$filename" ]; then
    echo "Error: File $filename already exists!" | tee -a "$LOG_FILE"
else
    tar -czvf "$dest/$filename" "$backup_file"
    echo
    echo "Backup completed successfully. Backup file: $dest/$filename" | tee -a "$LOG_FILE"
    echo

    # Upload to S3
    aws s3 cp "$FILE_TO_UPLODE" "s3://$s3_bucket/"
    if [ $? -eq 0 ]; then
        echo
        echo "File uploaded successfully to the S3 bucket $s3_bucket" | tee -a "$LOG_FILE"
    else
        echo "File upload to S3 failed" | tee -a "$LOG_FILE"
    fi
fi

