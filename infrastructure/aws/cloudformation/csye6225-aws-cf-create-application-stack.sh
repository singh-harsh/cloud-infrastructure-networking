
read -p "Enter network stack name: " networkStackname
while read a ; do echo ${a//STACK_NAME/$networkStackname} ; done < csye6225-cf-networking.json > csye6225-cf-networking.json.t ; mv csye6225-cf-networking.json{.t,}
echo "Creating network stack '$networkStackname' using cloudformation template csye6225-cf-networking.json..."
aws cloudformation create-stack --stack-name $networkStackname --template-body file://csye6225-cf-networking.json
aws cloudformation wait stack-create-complete --stack-name $networkStackname
CreatedStackList=$(aws cloudformation list-stacks --stack-status-filter CREATE_COMPLETE --query "StackSummaries[*].StackName" --output text)
if [[ $CreatedStackList = *"$networkStackname"* ]]; then
    echo "Network Stack $networkStackname created successfully"
    else
    echo "Network Stack $stackname creation failed"
fi
read -p "Enter application stack name: " applicationStackName
echo "Creating application stack '$applicationStackName' using cloudformation template csye6225-cf-application.json..."
s3DomainName=$(aws route53 list-hosted-zones-by-name --query HostedZones[0].Name --output text)
aws cloudformation create-stack --stack-name $applicationStackName --capabilities CAPABILITY_IAM --template-body file://csye6225-cf-application.json --parameters  ParameterKey=s3BucketName,ParameterValue=$s3DomainName"csye6225.com"
aws cloudformation wait stack-create-complete --stack-name $applicationStackName
CreatedStackList=$(aws cloudformation list-stacks --stack-status-filter CREATE_COMPLETE --query "StackSummaries[*].StackName" --output text)
if [[ $CreatedStackList = *"$applicationStackName"* ]]; then
    echo "Application Stack $applicationStackName created successfully"
    else
    echo "Application Stack $applicationStackName creation failed"
fi
