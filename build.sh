#!/bin/sh

CONTAINER_IMAGE_NAME=library/kube-goofys
CONTAINER_IMAGE_TAG=1.0.0
CONTAINER_REGISTORY_HOST=hub.docker.com

cd `dirname $0`

docker build -t ${CONTAINER_REGISTORY_HOST}/${CONTAINER_IMAGE_NAME}:${CONTAINER_IMAGE_TAG} -f build/Dockerfile .
docker push ${CONTAINER_REGISTORY_HOST}/${CONTAINER_IMAGE_NAME}:${CONTAINER_IMAGE_TAG}

cp helm-chart/values_template.yaml helm-chart/values.yaml

sed -i '' \
  "s/{ CONTAINER_REPOSITORY }/$CONTAINER_REGISTORY_HOST/g; \
  s/{ AWS_ACCESS_KEY_ID }/$AWS_ACCESS_KEY_ID/g; \
  s/{ AWS_SECRET_ACCESS_KEY }/$AWS_SECRET_ACCESS_KEY/g; \
  s/{ AWS_S3_BUCKETS_NAME }/$AWS_S3_BUCKETS_NAME/g" \
  helm-chart/values.yaml

