#APPLICATION STACK CREATION
read -p "Enter auto scaling application stack name: " applicationStackName
DNSRecordName=$(aws route53 list-hosted-zones-by-name --query HostedZones[0].Name --output text)
domainName=${DNSRecordName%?}
Ec2TagValue=csye6225-ec2
HostedZoneResourceId=$(aws route53 list-hosted-zones --query 'HostedZones[0].Id' --output text | cut -d "/" -f 3)
CertificateArnNumber=$(aws acm list-certificates --query CertificateSummaryList[0].CertificateArn --output text)
echo "Creating auto scaling application stack '$applicationStackName' using cloudformation template csye6225-cf-application.json..."
cfn-include csye6225-cf-auto-scaling-application.json -m > csye6225-cf-auto-scaling-application1.json
aws cloudformation create-stack --stack-name $applicationStackName --capabilities CAPABILITY_IAM --template-body file://csye6225-cf-auto-scaling-application1.json --parameters ParameterKey=domainName,ParameterValue=$domainName ParameterKey=HostedZoneResourceId,ParameterValue=$HostedZoneResourceId ParameterKey=CertificateArnNumber,ParameterValue=$CertificateArnNumber ParameterKey=DNSRecordName,ParameterValue=$DNSRecordName ParameterKey=Ec2TagValue,ParameterValue=$Ec2TagValue ParameterKey=StackName,ParameterValue=$applicationStackName
aws cloudformation wait stack-create-complete --stack-name $applicationStackName
CreatedStackList=$(aws cloudformation list-stacks --stack-status-filter CREATE_COMPLETE --query "StackSummaries[*].StackName" --output text)
if [[ $CreatedStackList = *"$applicationStackName"* ]]; then
    echo "Auto scaling application Stack $applicationStackName created successfully"
    else
    echo "Auto scaling application Stack $applicationStackName creation failed"
fi
rm csye6225-cf-auto-scaling-application1.json
