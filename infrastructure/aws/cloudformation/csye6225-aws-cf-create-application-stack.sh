#APPLICATION STACK CREATION
read -p "Enter application stack name: " applicationStackName
echo "Creating application stack '$applicationStackName' using cloudformation template csye6225-cf-application.json..."
aws cloudformation create-stack --stack-name $applicationStackName --capabilities CAPABILITY_IAM --template-body file://csye6225-cf-application.json
aws cloudformation wait stack-create-complete --stack-name $applicationStackName
CreatedStackList=$(aws cloudformation list-stacks --stack-status-filter CREATE_COMPLETE --query "StackSummaries[*].StackName" --output text)
if [[ $CreatedStackList = *"$applicationStackName"* ]]; then
    echo "Application Stack $applicationStackName created successfully"
    else
    echo "Application Stack $applicationStackName creation failed"
fi
