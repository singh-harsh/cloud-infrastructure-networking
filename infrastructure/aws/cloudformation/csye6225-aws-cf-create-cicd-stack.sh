#CICD STACK CREATION
echo "Enter CICD stack name" 
read cicdStackname
echo "Creating CICD stack $cicdStackname using cloudformation template csye6225-cf-cicd.json..."
echo "Enter Travis Username"
read travisUsername
Ec2TagValue=csye6225-ec2
accountNumber=$(aws sts get-caller-identity --output text --query 'Account')
region=$(aws configure get region)
domainName=$(aws route53 list-hosted-zones-by-name --query HostedZones[0].Name --output text)
domainName=${domainName%?}
s3WebApi=$domainName.csye6225.com
s3CodeDeploy=code-deploy.$domainName
s3LambdaUpload=lambda.$domainName
aws cloudformation create-stack --stack-name $cicdStackname --capabilities CAPABILITY_NAMED_IAM --template-body file://csye6225-cf-cicd.json --parameters  ParameterKey=region,ParameterValue=$region ParameterKey=account,ParameterValue=$accountNumber ParameterKey=s3BucketCodeDeployName,ParameterValue=$s3CodeDeploy ParameterKey=travisIAMUsername,ParameterValue=$travisUsername ParameterKey=Ec2TagValue,ParameterValue=$Ec2TagValue ParameterKey=s3BucketWebApiName,ParameterValue=$s3WebApi ParameterKey=s3LambdaUpload,ParameterValue=$s3LambdaUpload  
aws cloudformation wait stack-create-complete --stack-name $cicdStackname
CreatedStackList=$(aws cloudformation list-stacks --stack-status-filter CREATE_COMPLETE --query "StackSummaries[*].StackName" --output text)
if [[ $CreatedStackList = *"$cicdStackname"* ]]; then
    echo "CICD Stack '$cicdStackname' created successfully"
    else
    echo "CICD Stack '$cicdStackname' creation failed"
fi

#APPLICATION STACK CREATION CALL
sh ./csye6225-aws-cf-create-application-stack.sh