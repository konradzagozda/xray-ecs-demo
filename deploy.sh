#!/bin/bash
set -ex

# example usage:
# ./deploy.sh my-aws-profile 0.0.1

export AWS_PROFILE=${1}
TAG=${2}

# create ECR and the application image
terraform -chdir=infra/1.ecr init
terraform -chdir=infra/1.ecr apply -auto-approve

REPO_NAME=$(terraform -chdir=infra/1.ecr output -raw repository_name)
REPO_URL_BASE=$(terraform -chdir=infra/1.ecr output -raw repository_url_base)

./build.sh "$AWS_PROFILE" "$REPO_URL_BASE" "$REPO_NAME" "$TAG"

# create ECS cluster, task definition, service, dynamodb table
terraform -chdir=infra/2.ecs init
terraform -chdir=infra/2.ecs apply -auto-approve -var="image_url=$REPO_URL_BASE/$REPO_NAME:$TAG"

# wait for task to be created
sleep 30

# fetch public IP
TASK_ARN=$(aws ecs list-tasks --cluster app_with_xray --service-name app_with_xray --query 'taskArns' --output text)
ENI_ID=$(aws ecs describe-tasks --cluster app_with_xray --tasks "$TASK_ARN" --query 'tasks[0].attachments[0].details[?name==`networkInterfaceId`].value' --output text)
PUBLIC_IP=$(aws ec2 describe-network-interfaces --network-interface-ids "$ENI_ID" --query 'NetworkInterfaces[0].Association.PublicIp' --output text)

echo "Deploy finished, service is available at: $PUBLIC_IP:5000"
