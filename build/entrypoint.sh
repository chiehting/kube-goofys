#!/bin/sh

set -e

`dirname $0`/stop.sh

MOUNT_POINT="${MOUNT_POINT:-/mnt}"
AWS_S3_BUCKETS_NAME="$AWS_S3_BUCKETS_NAME"

#AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY_ID"
#AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY"

#if [ -z "$AWS_ACCESS_KEY_ID" ] || [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
#  echo "AWS_ACCESS_KEY_ID or AWS_SECRET_ACCESS_KEY is empty!"
#  exit 1
#fi

if [ -z "$AWS_S3_BUCKETS_NAME" ]; then
  echo "AWS_S3_BUCKETS_NAME is empty!"
  exit 1
fi


echo "starting..."
IFS=','
for bucketName in $AWS_S3_BUCKETS_NAME;
do
  bucket=${bucketName// /}
  echo "mount $bucket to $MOUNT_POINT/$bucket"
  mkdir -p $MOUNT_POINT/$bucket
  # The command goofys have an argument --debug_fuse --debug_s3, It's can enable fuse-related debugging output.
  goofys -o allow_other --use-content-type --dir-mode=0777 --debug_fuse -f $bucket $MOUNT_POINT/$bucket 2>&1 &
done

tail -f /proc/1/fd/1

