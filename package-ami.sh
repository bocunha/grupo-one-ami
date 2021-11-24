#!/bin/bash -vx

VERSAO=$(git describe --tags $(git rev-list --tags --max-count=1))

cd terraform

RESOURCE_ID=$(terraform output | grep resource_id | awk '{print $2;exit}' | sed -e "s/\",//g")

cd ../terraform-ami
terraform init
TF_VAR_versao=$VERSAO TF_VAR_resource_id=$RESOURCE_ID terraform apply -auto-approve

AMIID=$(terraform output | grep AMI | sed -e "s/\",//g" | awk '{ print $2 }')

echo "${AMIID}" > /tmp/k8s-ami-id.tmp