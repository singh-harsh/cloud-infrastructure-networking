read -p "Enter stack name: " stackname
echo "Deleting stack '$stackname'..."
aws cloudformation delete-stack --stack-name $stackname
aws cloudformation wait stack-delete-complete --stack-name $stackname
DeletedStackList=$(aws cloudformation list-stacks --stack-status-filter DELETE_COMPLETE --query "StackSummaries[*].StackName" --output text)
if [[ $DeletedStackList = *"$stackname"* ]]; then
    echo "Stack $stackname deleted successfully"
    else
    echo "Stack $stackname does not exist"
fi