#!/bin/bash
########################################
### AWS APPLICATION DELETION SCRIPT#######
########################################

read -p "Enter application stack name: " applicationStackName

EC2_INSTANCE_ID=$(aws cloudformation describe-stack-resource --stack-name $applicationStackName --logical-resource-id "MyEC2Instance" --query StackResourceDetail.PhysicalResourceId --output text)

echo EC2 instance with id $EC2_INSTANCE_ID found
echo "Disabling ec2 instance..."
aws ec2 modify-instance-attribute --instance-id $EC2_INSTANCE_ID --no-disable-api-termination

 if [ $? -eq 0 ]; then
    echo "EC2 instance disabled"
 else
    echo "Error occured in deleting EC2 instance"
    exit 1
 fi

aws ec2 terminate-instances --instance-ids $EC2_INSTANCE_ID
if [ $? -eq 0 ]; then
    echo "EC2 instance terminated"
 else
    echo "Error occured in terminating EC2 instance"
    exit 1
 fi

echo "Deleting stack '$applicationStackName'..."
webApiS3Bucket=$(aws cloudformation describe-stack-resource --stack-name $applicationStackName --logical-resource-id "RecordServiceS3Bucket" --query StackResourceDetail.PhysicalResourceId --output text)
echo "Emptying the S3 bucket..."
aws s3 rm s3://$webApiS3Bucket --recursive
aws cloudformation delete-stack --stack-name $applicationStackName
aws cloudformation wait stack-delete-complete --stack-name $applicationStackName

DeletedStackList=$(aws cloudformation list-stacks --stack-status-filter DELETE_COMPLETE --query "StackSummaries[*].StackName" --output text)
if [[ $DeletedStackList = *"$applicationStackName"* ]]; then
    echo "Stack $applicationStackName deleted successfully"
    else
    echo "Stack $applicationStackName does not exist"
    exit 1
fi
sh ./csye6225-aws-cf-terminate-cicd-stack.sh