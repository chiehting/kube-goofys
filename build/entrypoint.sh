#!/bin/sh

set -e

LOG_DIR="/var/log"
MOUNT_POINT="${MOUNT_POINT:-/mnt}"
AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY_ID"
AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY"
AWS_S3_BUCKETS_NAME="$AWS_S3_BUCKETS_NAME"

if [ -z "$AWS_ACCESS_KEY_ID" ] || [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
  echo "AWS_ACCESS_KEY_ID or AWS_SECRET_ACCESS_KEY is empty!"
  exit 1
fi

if [ -z "$AWS_S3_BUCKETS_NAME" ]; then
  echo "AWS_S3_BUCKETS_NAME is empty!"
  exit 1
fi


echo "starting..."
for bucket in $AWS_S3_BUCKETS_NAME;
do
  echo "mount $bucket to $MOUNT_POINT/$bucket"
  mkdir -p $MOUNT_POINT/$bucket $LOG_DIR
  touch $LOG_DIR/$bucket.log
  goofys --use-content-type --debug_fuse -f $bucket $MOUNT_POINT/$bucket >> $LOG_DIR/$bucket.log 2>&1 &
done

tail -f $LOG_DIR/*.log

