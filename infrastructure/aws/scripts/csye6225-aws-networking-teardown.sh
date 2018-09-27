#!/bin/bash
#******************************************************************************
#    AWS VPC Deletion  Shell Script
#******************************************************************************
echo "Enter VPC ID to delete"

read VPC_ID
vpcs=$(aws ec2 describe-vpcs --query "Vpcs[*].VpcId" --output text)
if [[ $vpcs = *"$VPC_ID"* ]]; then 
SUBNET_ID_1=$(aws ec2 describe-subnets --filters "Name=vpc-id, Values=$VPC_ID" --query "Subnets[0].SubnetId" --output text)
SUBNET_ID_2=$(aws ec2 describe-subnets --filters "Name=vpc-id, Values=$VPC_ID" --query "Subnets[1].SubnetId" --output text)
SUBNET_ID_3=$(aws ec2 describe-subnets --filters "Name=vpc-id, Values=$VPC_ID" --query "Subnets[2].SubnetId" --output text)
SUBNET_ID_4=$(aws ec2 describe-subnets --filters "Name=vpc-id, Values=$VPC_ID" --query "Subnets[3].SubnetId" --output text)
SUBNET_ID_5=$(aws ec2 describe-subnets --filters "Name=vpc-id, Values=$VPC_ID" --query "Subnets[4].SubnetId" --output text)
SUBNET_ID_6=$(aws ec2 describe-subnets --filters "Name=vpc-id, Values=$VPC_ID" --query "Subnets[5].SubnetId" --output text)

ASSOCIATION_ID_1=$(aws ec2 describe-route-tables --query "RouteTables[*].Associations[?SubnetId=='$SUBNET_ID_1'].RouteTableAssociationId" --output text)
ASSOCIATION_ID_2=$(aws ec2 describe-route-tables --query "RouteTables[*].Associations[?SubnetId=='$SUBNET_ID_2'].RouteTableAssociationId" --output text)
ASSOCIATION_ID_3=$(aws ec2 describe-route-tables --query "RouteTables[*].Associations[?SubnetId=='$SUBNET_ID_3'].RouteTableAssociationId" --output text)
ASSOCIATION_ID_4=$(aws ec2 describe-route-tables --query "RouteTables[*].Associations[?SubnetId=='$SUBNET_ID_4'].RouteTableAssociationId" --output text)
ASSOCIATION_ID_5=$(aws ec2 describe-route-tables --query "RouteTables[*].Associations[?SubnetId=='$SUBNET_ID_5'].RouteTableAssociationId" --output text)
ASSOCIATION_ID_6=$(aws ec2 describe-route-tables --query "RouteTables[*].Associations[?SubnetId=='$SUBNET_ID_6'].RouteTableAssociationId" --output text)

ROUTE_TABLE_ID=$(aws ec2 describe-route-tables --query "RouteTables[*].Associations[?SubnetId=='$SUBNET_ID_1'].RouteTableId" --output text)
INTERNET_GATEWAY_ID=$(aws ec2 describe-internet-gateways --filters "Name=attachment.vpc-id,Values=$VPC_ID" --query "InternetGateways[0].InternetGatewayId" --output text)

#Dissassociating routes from route table
echo Disassociating Subnet 1
aws ec2 disassociate-route-table --association-id $ASSOCIATION_ID_1
if [ $? -eq 0 ]; then
	echo $SUBNET_ID_1 with association id $ASSOCIATION_ID_1 disassociated from routable
else
	echo Error in deleting $SUBNET_ID_1 with association id $ASSOCIATION_ID_1
	exit 1
fi

echo Disassociating Subnet 2
aws ec2 disassociate-route-table --association-id $ASSOCIATION_ID_2
if [ $? -eq 0 ]; then
	echo $SUBNET_ID_2 with association id $ASSOCIATION_ID_2 disassociated from routable
else
	echo Error in deleting $SUBNET_ID_2 with association id $ASSOCIATION_ID_2
	exit 1
fi

echo Disassociating Subnet 3
aws ec2 disassociate-route-table --association-id $ASSOCIATION_ID_3
if [ $? -eq 0 ]; then
	echo $SUBNET_ID_3 with association id $ASSOCIATION_ID_3 disassociated from routable
else
	echo Error in deleting $SUBNET_ID_3 with association id $ASSOCIATION_ID_3
	exit 1
fi

echo Disassociating Subnet 4
aws ec2 disassociate-route-table --association-id $ASSOCIATION_ID_4
if [ $? -eq 0 ]; then
	echo $SUBNET_ID_4 with association id $ASSOCIATION_ID_4 disassociated from routable
else
	echo Error in deleting $SUBNET_ID_4 with association id $ASSOCIATION_ID_4
	exit 1
fi

echo Disassociating Subnet 5
aws ec2 disassociate-route-table --association-id $ASSOCIATION_ID_5
if [ $? -eq 0 ]; then
	echo $SUBNET_ID_5 with association id $ASSOCIATION_ID_5 disassociated from routable
else
	echo Error in deleting $SUBNET_ID_5 with association id $ASSOCIATION_ID_5
	exit 1
fi

echo Disassociating Subnet 6
aws ec2 disassociate-route-table --association-id $ASSOCIATION_ID_6

if [ $? -eq 0 ]; then
	echo $SUBNET_ID_6 with association id $ASSOCIATION_ID_6 disassociated from routable
else
	echo Error in deleting $SUBNET_ID_6 with association id $ASSOCIATION_ID_6
	exit 1
fi

#DELETING ROUTE TABLE
echo Deleting Route Table
aws ec2 delete-route-table --route-table-id $ROUTE_TABLE_ID
if [ $? -eq 0 ]; then
	echo Route table with id $ROUTE_TABLE_ID deleted
else
	echo Error in deleting $ROUTE_TABLE_ID
	exit 1
fi

#DETACH INTERNET GATEWAY FROM VPC
echo Detach Internet Gateway from VPC
aws ec2 detach-internet-gateway --internet-gateway-id $INTERNET_GATEWAY_ID --vpc-id $VPC_ID

if [ $? -eq 0 ]; then
	echo Internet Gateway with Id $INTERNET_GATEWAY_ID detached from VPC with ID $VPC_ID
else
	echo Error in detaching $INTERNET_GATEWAY_ID from VPC $VPC_ID
	exit 1
fi

#DELETE INTERNET GATEWAY 
echo Deleting Internet Gateway
aws ec2 delete-internet-gateway --internet-gateway-id $INTERNET_GATEWAY_ID


if [ $? -eq 0 ]; then
	echo Internet Gateway with Id $INTERNET_GATEWAY_ID deleted
else
	echo Error in deleting $INTERNET_GATEWAY_ID
	exit 1
fi

#Deleting Subnets
echo Deleteing Subnet 1
aws ec2 delete-subnet --subnet-id $SUBNET_ID_1


if [ $? -eq 0 ]; then
	echo $SUBNET_ID_1 deleted
else
	echo Error in deleting $SUBNET_ID_1
	exit 1
fi

echo Deleteing Subnet 2
aws ec2 delete-subnet --subnet-id $SUBNET_ID_2
if [ $? -eq 0 ]; then
	echo $SUBNET_ID_2 deleted
else
	echo Error in deleting $SUBNET_ID_2
	exit 1
fi

echo Deleteing Subnet 3
aws ec2 delete-subnet --subnet-id $SUBNET_ID_3
if [ $? -eq 0 ]; then
	echo $SUBNET_ID_3 deleted
else
	echo Error in deleting $SUBNET_ID_3
	exit 1
fi

echo Deleteing Subnet 4
aws ec2 delete-subnet --subnet-id $SUBNET_ID_4

if [ $? -eq 0 ]; then
	echo $SUBNET_ID_4 deleted
else
	echo Error in deleting $SUBNET_ID_4
	exit 1
fi


echo Deleteing Subnet 5
aws ec2 delete-subnet --subnet-id $SUBNET_ID_5
if [ $? -eq 0 ]; then
	echo $SUBNET_ID_4 deleted
else
	echo Error in deleting $SUBNET_ID_5
	exit 1
fi


echo Deleteing Subnet 6
aws ec2 delete-subnet --subnet-id $SUBNET_ID_6
if [ $? -eq 0 ]; then
	echo $SUBNET_ID_6 deleted
else
	echo Error in deleting $SUBNET_ID_6
	exit 1
fi

#Deleting VPC
aws ec2 delete-vpc --vpc-id $VPC_ID
echo $VPC_ID deleted.
else
echo "VPC ID $VPC_ID entered does not exist"
exit 1
fi
