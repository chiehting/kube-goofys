#!/bin/sh

set -e

LOG_DIR="/var/log/goofys"
MOUNT_POINT="${MOUNT_POINT:-/mnt}"
AWS_S3_BUCKETS_NAME="$AWS_S3_BUCKETS_NAME"

echo "starting..."
for bucket in $AWS_S3_BUCKETS_NAME;
do
  echo "umount $bucket to $MOUNT_POINT/$bucket"
  umount $MOUNT_POINT/$bucket
done

