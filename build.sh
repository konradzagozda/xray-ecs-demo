#!/bin/bash

# examplke usage:
# ./build.sh 817861099197.dkr.ecr.us-west-2.amazonaws.com app-with-xray 0.0.1


ECR_URL=${1:-latest}
REPO_NAME=${2:-latest}
TAG=${3:-latest}

export AWS_PROFILE=kz_wp
docker build --platform=linux/amd64 -t $REPO_NAME:$TAG .
aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin $ECR_URL
docker tag $REPO_NAME:$TAG $ECR_URL/$REPO_NAME:$TAG
docker push $ECR_URL/$REPO_NAME:$TAG