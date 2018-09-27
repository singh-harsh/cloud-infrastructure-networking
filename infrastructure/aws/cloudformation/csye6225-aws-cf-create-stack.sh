read -p "Enter stack name: " stackname
while read a ; do echo ${a//STACK_NAME/$stackname} ; done < csye6225-cf-networking.json > csye6225-cf-networking.json.t ; mv csye6225-cf-networking.json{.t,}
echo "Creating stack '$stackname' using cloudformation template csye6225-cf-networking.json..."
aws cloudformation create-stack --stack-name $stackname --template-body file:///home/hvs/CloudComputing/Assignment2/csye6225-cf-networking.json
aws cloudformation wait stack-create-complete --stack-name $stackname
CreatedStackList=$(aws cloudformation list-stacks --stack-status-filter CREATE_COMPLETE --query "StackSummaries[*].StackName" --output text)
if [[ $CreatedStackList = *"$stackname"* ]]; then
    echo "Stack $stackname created successfully"
    else
    echo "Stack $stackname creation failed"
fi