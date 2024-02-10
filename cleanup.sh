#!/bin/bash
set -ex

# Clean up after yourself to avoid aws costs

# example usage:
# ./cleanup.sh my-aws-profile

export AWS_PROFILE=${1}
REPO_NAME=$(terraform -chdir="infra/1.ecr" output -raw repository_name)
REPO_URL_BASE=$(terraform -chdir="infra/1.ecr" output -raw repository_url_base)

terraform -chdir="infra/2.ecs" destroy -var="image_url=$REPO_URL_BASE/$REPO_NAME" --auto-approve

terraform -chdir="infra/1.ecr" destroy --auto-approve