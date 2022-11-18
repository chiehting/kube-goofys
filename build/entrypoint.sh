#!/bin/sh

set -e

MOUNT_POINT="${MOUNT_POINT:-/mnt}"
LOG_DIR="${MOUNT_POINT}/log"
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
mkdir -p $LOG_DIR
IFS=','
for bucketName in $AWS_S3_BUCKETS_NAME;
do
  bucket=${bucketName// /}
  echo "mount $bucket to $MOUNT_POINT/$bucket"
  mkdir -p $MOUNT_POINT/$bucket
  touch $LOG_DIR/$bucket.log
  # The command goofys have an argument --debug_fuse, It's can enable fuse-related debugging output.
  goofys -o allow_other --use-content-type --dir-mode=0777 --debug_s3 -f $bucket $MOUNT_POINT/$bucket >> $LOG_DIR/$bucket.log 2>&1 &
done

tail -f $LOG_DIR/*.log

