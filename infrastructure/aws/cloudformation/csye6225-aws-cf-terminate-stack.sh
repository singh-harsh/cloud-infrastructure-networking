echo "Do you want to delete the network stack(y/n):" 
read choice
while [ "$choice" != "y" ] || [ "$choice" != "n" ]; do  
if [ "$choice" = "y" ]; then
read -p "Enter stack name: " STACK_NAME_2
echo "Deleting stack '$STACK_NAME_2'..."
aws cloudformation delete-stack --stack-name $STACK_NAME_2
aws cloudformation wait stack-delete-complete --stack-name $STACK_NAME_2

DeletedStackList=$(aws cloudformation list-stacks --stack-status-filter DELETE_COMPLETE --query "StackSummaries[*].StackName" --output text)
if [[ $DeletedStackList = *"$STACK_NAME_2"* ]]; then
    echo "Stack $STACK_NAME_2 deleted successfully"
    exit 1;
    else
    echo "Stack $STACK_NAME_2 does not exist"
    exit 1
fi
elif [ "$choice" = "n" ]; then
exit 1;
else 
echo "Do you want to delete the network stack(y/n): " 
read choice
fi
done
exit 1;