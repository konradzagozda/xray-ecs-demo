#!/bin/bash

# usage:
# ./build.sh 0.0.1

TAG=${1:-latest}

export AWS_PROFILE=kz_wp
docker build --platform=linux/amd64 -t app-with-xray:$TAG .
aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 817861099197.dkr.ecr.us-west-2.amazonaws.com
docker tag app-with-xray:$TAG 817861099197.dkr.ecr.us-west-2.amazonaws.com/app-with-xray:$TAG
docker push 817861099197.dkr.ecr.us-west-2.amazonaws.com/app-with-xray:$TAG