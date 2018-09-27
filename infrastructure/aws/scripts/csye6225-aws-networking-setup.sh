#!/bin/bash
########################################
### AWS VPC CREATION SHELL SCRIPT#######
########################################
AWS_REGION=$(aws ec2 describe-regions --query "Regions[11].{Name:RegionName}" --output text)
VPC_NAME="CSYE6225_VPC"
VPC_CIDR="10.0.0.0/16"
SUBNET_PUBLIC_CIDR_1="10.0.1.0/24"
SUBNET_PRIVATE_CIDR_1="10.0.2.0/24"
SUBNET_AZ_1=$(aws ec2 describe-availability-zones --query "AvailabilityZones[0].ZoneName" --output text)
SUBNET_PUBLIC_NAME_1="PUBLIC - $SUBNET_AZ_1"
SUBNET_PRIVATE_NAME_1="PRIVATE - $SUBNET_AZ_1"

SUBNET_PUBLIC_CIDR_2="10.0.3.0/24"
SUBNET_PRIVATE_CIDR_2="10.0.4.0/24"
SUBNET_AZ_2=$(aws ec2 describe-availability-zones --query "AvailabilityZones[1].ZoneName" --output text)
SUBNET_PUBLIC_NAME_2="PUBLIC - $SUBNET_AZ_2"
SUBNET_PRIVATE_NAME_2="PRIVATE - $SUBNET_AZ_2"

SUBNET_PUBLIC_CIDR_3="10.0.5.0/24"
SUBNET_PRIVATE_CIDR_3="10.0.6.0/24"
SUBNET_AZ_3=$(aws ec2 describe-availability-zones --query "AvailabilityZones[2].ZoneName" --output text)
SUBNET_PUBLIC_NAME_3="PUBLIC - $SUBNET_AZ_3"
SUBNET_PRIVATE_NAME_3="PRIVATE - $SUBNET_AZ_3"

INTERNET_GATEWAY_NAME="CSYE6225_IG"
ROUTE_TABLE_NAME="CSYE6225_RT"

# Create VPC
echo "Creating VPC in preferred region..."
VPC_ID=$(aws ec2 create-vpc \
  --cidr-block $VPC_CIDR \
  --query 'Vpc.{VpcId:VpcId}' \
  --output text \
  --region $AWS_REGION)
  if [ $? -eq 0 ]; then 
    echo "  VPC ID '$VPC_ID' CREATED in '$AWS_REGION' region."
  else
    echo "VPC not created due to error"
    exit 1
  fi

# Add Name tag to VPC
aws ec2 create-tags \
  --resources $VPC_ID \
  --tags "Key=Name,Value=$VPC_NAME" \
  --region $AWS_REGION
  if [ $? -eq 0 ]; then
    echo "  VPC ID '$VPC_ID' NAMED as '$VPC_NAME'."
  else
    echo "Tag Name not Added to VPC"
    exit 1
  fi

# Create Private Subnet 1
echo "Creating Private Subnet 1..."
SUBNET_PRIVATE_ID_1=$(aws ec2 create-subnet \
  --vpc-id $VPC_ID \
  --cidr-block $SUBNET_PRIVATE_CIDR_1 \
  --availability-zone $SUBNET_AZ_1 \
  --query 'Subnet.{SubnetId:SubnetId}' \
  --output text \
  --region $AWS_REGION)
  if [ $? -eq 0 ]; then
    echo "  Subnet ID '$SUBNET_PRIVATE_ID_1' CREATED in '$SUBNET_AZ_1'" \
      "Availability Zone."
  else
    echo "Private Subnet 1 not created"
  fi

# Add Name tag to Private Subnet 1
aws ec2 create-tags \
  --resources $SUBNET_PRIVATE_ID_1 \
  --tags "Key=Name,Value=$SUBNET_PRIVATE_NAME_1" \
  --region $AWS_REGION
  if [ $? -eq 0 ]; then
    echo "  Subnet ID '$SUBNET_PRIVATE_ID_1' NAMED as '$SUBNET_PRIVATE_NAME_1'."
  else
    echo "Tag Name not added to Private Subnet 1"
  fi

# Create Public Subnet 1
echo "Creating Public Subnet 1..."
SUBNET_PUBLIC_ID_1=$(aws ec2 create-subnet \
  --vpc-id $VPC_ID \
  --cidr-block $SUBNET_PUBLIC_CIDR_1 \
  --availability-zone $SUBNET_AZ_1 \
  --query 'Subnet.{SubnetId:SubnetId}' \
  --output text \
  --region $AWS_REGION)
  if [ $? -eq 0 ]; then
    echo "  Subnet ID '$SUBNET_PUBLIC_ID_1' CREATED in '$SUBNET_AZ_1'" \
    "Availability Zone."
  else
    echo "Public Subnet 1 not created"
  fi

# Add Name tag to Public Subnet 1
aws ec2 create-tags \
  --resources $SUBNET_PUBLIC_ID_1 \
  --tags "Key=Name,Value=$SUBNET_PUBLIC_NAME_1" \
  --region $AWS_REGION
  if [ $? -eq 0 ]; then
    echo "  Subnet ID '$SUBNET_PUBLIC_ID_1' NAMED as" \
    "'$SUBNET_PUBLIC_NAME_1'."
  else
    echo " Tag Name not Added to Public Subnet 1"
  fi

# Create Private Subnet 2
echo "Creating Private Subnet 2..."
SUBNET_PRIVATE_ID_2=$(aws ec2 create-subnet \
  --vpc-id $VPC_ID \
  --cidr-block $SUBNET_PRIVATE_CIDR_2 \
  --availability-zone $SUBNET_AZ_2 \
  --query 'Subnet.{SubnetId:SubnetId}' \
  --output text \
  --region $AWS_REGION)
  if [ $? -eq 0 ]; then
    echo "  Subnet ID '$SUBNET_PRIVATE_ID_2' CREATED in '$SUBNET_AZ_2'" \
    "Availability Zone."
  else
   echo "Private Subnet 2 not created"
  fi

# Add Name tag to Private Subnet 2
aws ec2 create-tags \
  --resources $SUBNET_PRIVATE_ID_2 \
  --tags "Key=Name,Value=$SUBNET_PRIVATE_NAME_2" \
  --region $AWS_REGION
if [ $? -eq 0 ]; then
  echo "  Subnet ID '$SUBNET_PRIVATE_ID_2' NAMED as '$SUBNET_PRIVATE_NAME_2'."
else
    echo " Tag Name not Added to Private Subnet 2"
  fi 

# Create Public Subnet 2
echo "Creating Public Subnet 2..."
SUBNET_PUBLIC_ID_2=$(aws ec2 create-subnet \
  --vpc-id $VPC_ID \
  --cidr-block $SUBNET_PUBLIC_CIDR_2 \
  --availability-zone $SUBNET_AZ_2 \
  --query 'Subnet.{SubnetId:SubnetId}' \
  --output text \
  --region $AWS_REGION)
if [ $? -eq 0 ]; then 
  echo "  Subnet ID '$SUBNET_PUBLIC_ID_2' CREATED in '$SUBNET_AZ_2'" \
  "Availability Zone."
else
  echo " Public Subnet 2 not created"
fi

# Add Name tag to Public Subnet 2
aws ec2 create-tags \
  --resources $SUBNET_PUBLIC_ID_2 \
  --tags "Key=Name,Value=$SUBNET_PUBLIC_NAME_2" \
  --region $AWS_REGION
echo "  Subnet ID '$SUBNET_PUBLIC_ID_2' NAMED as" \
  "'$SUBNET_PUBLIC_NAME_2'."


# Create Private Subnet 3
echo "Creating Private Subnet 3..."
SUBNET_PRIVATE_ID_3=$(aws ec2 create-subnet \
  --vpc-id $VPC_ID \
  --cidr-block $SUBNET_PRIVATE_CIDR_3 \
  --availability-zone $SUBNET_AZ_3 \
  --query 'Subnet.{SubnetId:SubnetId}' \
  --output text \
  --region $AWS_REGION)
echo "  Subnet ID '$SUBNET_PRIVATE_ID_3' CREATED in '$SUBNET_AZ_3'" \
  "Availability Zone."

# Add Name tag to Private Subnet 3
aws ec2 create-tags \
  --resources $SUBNET_PRIVATE_ID_3 \
  --tags "Key=Name,Value=$SUBNET_PRIVATE_NAME_3" \
  --region $AWS_REGION
echo "  Subnet ID '$SUBNET_PRIVATE_ID_3' NAMED as '$SUBNET_PRIVATE_NAME_3'."

# Create Public Subnet 3
echo "Creating Public Subnet 3..."
SUBNET_PUBLIC_ID_3=$(aws ec2 create-subnet \
  --vpc-id $VPC_ID \
  --cidr-block $SUBNET_PUBLIC_CIDR_3 \
  --availability-zone $SUBNET_AZ_3 \
  --query 'Subnet.{SubnetId:SubnetId}' \
  --output text \
  --region $AWS_REGION)
echo "  Subnet ID '$SUBNET_PUBLIC_ID_3' CREATED in '$SUBNET_AZ_3'" \
  "Availability Zone."

# Add Name tag to Public Subnet 3
aws ec2 create-tags \
  --resources $SUBNET_PUBLIC_ID_3 \
  --tags "Key=Name,Value=$SUBNET_PUBLIC_NAME_3" \
  --region $AWS_REGION
echo "  Subnet ID '$SUBNET_PUBLIC_ID_3' NAMED as" \
  "'$SUBNET_PUBLIC_NAME_3'."

# Create Internet gateway
echo "Creating Internet Gateway..."
IGW_ID=$(aws ec2 create-internet-gateway \
  --query 'InternetGateway.{InternetGatewayId:InternetGatewayId}' \
  --output text \
  --region $AWS_REGION)
echo "  Internet Gateway ID '$IGW_ID' CREATED."

#Add Name Tag to Internet Gateway
aws ec2 create-tags \
	--resources $IGW_ID \
	--tags "Key=Name,Value=$INTERNET_GATEWAY_NAME" \
	--region $AWS_REGION
echo " Internet Gateway '$IGW_ID' NAMED AS '$INTERNET_GATEWAY_NAME'"

# Attach Internet gateway to your VPC
aws ec2 attach-internet-gateway \
  --vpc-id $VPC_ID \
  --internet-gateway-id $IGW_ID \
  --region $AWS_REGION
echo "  Internet Gateway ID '$IGW_ID' ATTACHED to VPC ID '$VPC_ID'."

# Create Route Table
echo "Creating Route Table..."
ROUTE_TABLE_ID=$(aws ec2 create-route-table \
  --vpc-id $VPC_ID \
  --query 'RouteTable.{RouteTableId:RouteTableId}' \
  --output text \
  --region $AWS_REGION)
echo "  Route Table ID '$ROUTE_TABLE_ID' CREATED."

#Add Name Tag to Route Table
aws ec2 create-tags \
        --resources $ROUTE_TABLE_ID \
        --tags "Key=Name,Value=$ROUTE_TABLE_NAME" \
        --region $AWS_REGION
echo " Internet Gateway '$ROUTE_TABLE_ID' NAMED AS '$ROUTE_TABLE_NAME'"

#Associate Subnets to Route Table

ASSOCIATE_PRIVATE_ID_1=$(aws ec2 associate-route-table  \
  --subnet-id $SUBNET_PRIVATE_ID_1 \
  --route-table-id $ROUTE_TABLE_ID \
  --region $AWS_REGION)
echo "  Public Subnet ID '$SUBNET_PRIVATE_ID_1' ASSOCIATED with Associated Id $ASSOCIATE_PRIVATE_ID_1 with Route Table ID" \
  "'$ROUTE_TABLE_ID'."

ASSOCIATE_PUBLIC_ID_1=$(aws ec2 associate-route-table  \
  --subnet-id $SUBNET_PUBLIC_ID_1 \
  --route-table-id $ROUTE_TABLE_ID \
  --region $AWS_REGION)
echo "  Public Subnet ID '$SUBNET_PUBLIC_ID_1' ASSOCIATED with Associated Id $ASSOCIATE_PUBLIC_ID_1 with Route Table ID" \
  "'$ROUTE_TABLE_ID'."

ASSOCIATE_PRIVATE_ID_2=$(aws ec2 associate-route-table  \
  --subnet-id $SUBNET_PRIVATE_ID_2 \
  --route-table-id $ROUTE_TABLE_ID \
  --region $AWS_REGION)
echo "  Public Subnet ID '$SUBNET_PRIVATE_ID_2' ASSOCIATED with Associated Id $ASSOCIATE_PRIVATE_ID_2 with Route Table ID" \
  "'$ROUTE_TABLE_ID'."


ASSOCIATE_PUBLIC_ID_2=$(aws ec2 associate-route-table  \
  --subnet-id $SUBNET_PUBLIC_ID_2 \
  --route-table-id $ROUTE_TABLE_ID \
  --region $AWS_REGION)
echo "  Public Subnet ID '$SUBNET_PUBLIC_ID_2' ASSOCIATED with Associated Id $ASSOCIATE_PUBLIC_ID_2 with Route Table ID" \
  "'$ROUTE_TABLE_ID'."

ASSOCIATE_PRIVATE_ID_3=$(aws ec2 associate-route-table  \
  --subnet-id $SUBNET_PRIVATE_ID_3 \
  --route-table-id $ROUTE_TABLE_ID \
  --region $AWS_REGION)
echo "  Public Subnet ID '$SUBNET_PRIVATE_ID_3' ASSOCIATED with Associated Id $ASSOCIATE_PRIVATE_ID_3 with Route Table ID" \
  "'$ROUTE_TABLE_ID'."

ASSOCIATE_PUBLIC_ID_3=$(aws ec2 associate-route-table  \
  --subnet-id $SUBNET_PUBLIC_ID_3 \
  --route-table-id $ROUTE_TABLE_ID \
  --region $AWS_REGION)
echo "  Public Subnet ID '$SUBNET_PUBLIC_ID_3' ASSOCIATED with Associated Id $ASSOCIATE_PUBLIC_ID_3 with Route Table ID" \
  "'$ROUTE_TABLE_ID'."


# Create route to Internet Gateway
ROUTE_ID=$(aws ec2 create-route \
  --route-table-id $ROUTE_TABLE_ID \
  --destination-cidr-block 0.0.0.0/0 \
  --gateway-id $IGW_ID \
  --region $AWS_REGION)
echo "  Route to '0.0.0.0/0' via Internet Gateway ID '$IGW_ID' ADDED to" \
  "Route Table ID '$ROUTE_TABLE_ID'."


