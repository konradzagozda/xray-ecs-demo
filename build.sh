#!/bin/bash
set -ex

# example usage:
# ./build.sh my-aws-profile 817861099197.dkr.ecr.us-west-2.amazonaws.com app-with-xray 0.0.1


AWS_PROFILE=${1}
ECR_URL=${2}
REPO_NAME=${3}
TAG=${4}

export AWS_PROFILE=${AWS_PROFILE}
docker build --platform=linux/amd64 -t $REPO_NAME:$TAG .
aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin $ECR_URL
docker tag $REPO_NAME:$TAG $ECR_URL/$REPO_NAME:$TAG
docker push $ECR_URL/$REPO_NAME:$TAG