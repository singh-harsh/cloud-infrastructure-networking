#!/bin/bash
########################################
### AWS APPLICATION DELETION SCRIPT#######
########################################
read -p "Enter stack name: " STACK_NAME_1

EC2_INSTANCE_ID=$(aws ec2 describe-instances --query Reservations[].Instances[].InstanceId --output text)

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


echo "Deleting stack '$STACK_NAME_1'..."
aws cloudformation delete-stack --stack-name $STACK_NAME_1
aws cloudformation wait stack-delete-complete --stack-name $STACK_NAME_1

DeletedStackList=$(aws cloudformation list-stacks --stack-status-filter DELETE_COMPLETE --query "StackSummaries[*].StackName" --output text)
if [[ $DeletedStackList = *"$STACK_NAME_1"* ]]; then
    echo "Stack $STACK_NAME_1 deleted successfully"
    else
    echo "Stack $STACK_NAME_1 does not exist"
    exit 1
fi

read -p "Enter stack name: " STACK_NAME_2
echo "Deleting stack '$STACK_NAME_2'..."
aws cloudformation delete-stack --stack-name $STACK_NAME_2
aws cloudformation wait stack-delete-complete --stack-name $STACK_NAME_2

DeletedStackList=$(aws cloudformation list-stacks --stack-status-filter DELETE_COMPLETE --query "StackSummaries[*].StackName" --output text)
if [[ $DeletedStackList = *"$STACK_NAME_2"* ]]; then
    echo "Stack $STACK_NAME_2 deleted successfully"
    else
    echo "Stack $STACK_NAME_2 does not exist"
    exit 1
fi