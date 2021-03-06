echo "Do you want to delete the cicd stack(y/n)" 
read choice
while [ "$choice" != "y" ] || [ "$choice" != "n" ]; do  
if [ "$choice" = "y" ]; then
read -p "Enter cicd stack name: " stackname
webApiS3Bucket=$(aws cloudformation describe-stack-resource --stack-name $stackname --logical-resource-id "S3BucketCodeDeploy" --query StackResourceDetail.PhysicalResourceId --output text)
echo "Emptying the S3 bucket..."
aws s3 rm s3://$webApiS3Bucket --recursive
echo "Deleting stack '$stackname'..."
aws cloudformation delete-stack --stack-name $stackname
aws cloudformation wait stack-delete-complete --stack-name $stackname
DeletedStackList=$(aws cloudformation list-stacks --stack-status-filter DELETE_COMPLETE --query "StackSummaries[*].StackName" --output text)
if [[ $DeletedStackList = *"$stackname"* ]]; then
    echo "CICD Stack "$stackname" deleted successfully"
    else
    echo "CICD Stack "$stackname" does not exist"
fi
sh ./csye6225-aws-cf-terminate-stack.sh
break
elif [ "$choice" = "n" ]; then
echo "CICD stack not deleted."
sh ./csye6225-aws-cf-terminate-stack.sh
break
else 
echo "Do you want to delete the cicd stack(y/n): " 
read choice
fi
done
