#!/bin/bash

bucket_name='s3-k8s-backend' 
build=plan-$(date +%d%m%y%H%M)

echo $(pwd)

aws s3 ls s3://"$bucket_name"

if [ $? -eq 0 ]; then echo "$bucket_name, bucket is available"; else aws s3 mb s3://$bucket_name --region ap-south-1; fi

sed -i "s/bucketname/$bucket_name/" backend.tf

terraform init

terraform plan -out=$build

echo "terraform apply $build -auto-approve"

terraform apply -auto-approve

aws s3 cp "$build" s3://"$bucket_name"


# Destroy all
# terraform destroy -auto-approve
