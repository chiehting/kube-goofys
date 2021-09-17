#!/bin/sh

export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
AWS_S3_BUCKETS_NAME=
AWS_ECR=

CONTAINER_IMAGE_NAME=kube-goofys
CONTAINER_IMAGE_TAG=1.0.0
CONTAINER_REGISTORY_HOST=dkr.ecr.ap-southeast-1.amazonaws.com


# auto get AWS ECR
if [ "$AWS_ECR" == "true" ]; then
  AWS_REGION=$(aws configure get region)
  CONTAINER_REGISTORY_HOST=$(aws sts get-caller-identity | jq -j .Account).dkr.ecr.${AWS_REGION}.amazonaws.com
  CONTAINER_REGISTORY_PASSWORD=$(aws ecr get-login-password --region ${AWS_REGION})

  aws ecr get-login-password --region $AWS_REGION  | docker login --username AWS --password-stdin ${CONTAINER_REGISTORY_HOST}
  aws ecr describe-repositories --repository-names ${CONTAINER_IMAGE_NAME} || aws ecr create-repository --repository-name ${CONTAINER_IMAGE_NAME}
fi

cd `dirname $0`

#docker build -t ${CONTAINER_REGISTORY_HOST}/${CONTAINER_IMAGE_NAME}:${CONTAINER_IMAGE_TAG} -f build/Dockerfile .
#docker push ${CONTAINER_REGISTORY_HOST}/${CONTAINER_IMAGE_NAME}:${CONTAINER_IMAGE_TAG}

cp helm-chart/values_template.yaml helm-chart/values.yaml
sed -i '' \
  "s/dkr.ecr.ap-southeast-1.amazonaws.com\/kube-goofys/$CONTAINER_REGISTORY_HOST/g; \
  s/{ AWS_ACCESS_KEY_ID }/$AWS_ACCESS_KEY_ID/g; \
  s/{ AWS_SECRET_ACCESS_KEY }/$AWS_SECRET_ACCESS_KEY/g; \
  s/{ AWS_S3_BUCKETS_NAME }/$AWS_S3_BUCKETS_NAME/g" \
  helm-chart/values.yaml

