#!/bin/sh

MOUNT_POINT="${MOUNT_POINT:-/mnt}"
AWS_S3_BUCKETS_NAME="$AWS_S3_BUCKETS_NAME"

echo "stoping..."
IFS=','
for bucketName in $AWS_S3_BUCKETS_NAME;
do
  bucket=${bucketName// /}
  umount -rlf $MOUNT_POINT/$bucket || /bin/true
  echo "umount $MOUNT_POINT/$bucket"
done

