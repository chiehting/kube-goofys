#!/bin/sh

set -e

LOG_DIR="/var/log/goofys"
MOUNT_POINT="${MOUNT_POINT:-/mnt}"
AWS_S3_BUCKETS_NAME="$AWS_S3_BUCKETS_NAME"

echo "starting..."
IFS=','
for bucketName in $AWS_S3_BUCKETS_NAME;
do
  bucket=${bucketName// /}
  echo "umount $bucket to $MOUNT_POINT/$bucket"
  umount $MOUNT_POINT/$bucket
done

