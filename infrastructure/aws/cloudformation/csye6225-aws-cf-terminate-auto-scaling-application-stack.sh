#!/bin/bash
########################################
### AWS APPLICATION DELETION SCRIPT#######
########################################

read -p "Enter auto scaling application stack name: " applicationStackName
echo "Emptying the S3 bucket..."
webApiS3Bucket=$(aws cloudformation describe-stack-resource --stack-name $applicationStackName --logical-resource-id "RecordServiceS3Bucket" --query StackResourceDetail.PhysicalResourceId --output text)
echo "Deleting stack '$applicationStackName'..."
aws s3 rm s3://$webApiS3Bucket --recursive
aws cloudformation delete-stack --stack-name $applicationStackName
aws cloudformation wait stack-delete-complete --stack-name $applicationStackName

DeletedStackList=$(aws cloudformation list-stacks --stack-status-filter DELETE_COMPLETE --query "StackSummaries[*].StackName" --output text)
if [[ $DeletedStackList = *"$applicationStackName"* ]]; then
    echo "Auto scaling application stack $applicationStackName deleted successfully"
    else
    echo "Auto scaling application stack $applicationStackName does not exist"
    exit 1
fi
sh ./csye6225-aws-cf-terminate-cicd-stack.sh