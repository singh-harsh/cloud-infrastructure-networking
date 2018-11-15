#SERVERLESS STACK CREATION
read -p "Enter serverless stack name: " serverlessStackname
echo "Creating serverless stack '$serverlessStackname' using cloudformation template csye6225-cf-serverless.json..."
domainName=$(aws route53 list-hosted-zones-by-name --query HostedZones[0].Name --output text)
domainName=${domainName%?}
s3Lambda=lambda.$domainName
aws cloudformation create-stack --stack-name $serverlessStackname --template-body file://csye6225-cf-serverless.json --parameters  ParameterKey=s3Lambda,ParameterValue=$s3Lambda
aws cloudformation wait stack-create-complete --stack-name $serverlessStackname
CreatedStackList=$(aws cloudformation list-stacks --stack-status-filter CREATE_COMPLETE --query "StackSummaries[*].StackName" --output text)
if [[ $CreatedStackList = *"$serverlessStackname"* ]]; then
    echo "serverless Stack $serverlessStackname created successfully"
    else
    echo "serverless Stack $stackname creation failed"
fi