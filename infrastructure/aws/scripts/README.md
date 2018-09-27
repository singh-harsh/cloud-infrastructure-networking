# Description
1.csye6225-aws-networking-setup.sh - The following file is used to create and configure necessary network resources using AWS CLI
2.csye6225-aws-networking-teardown.sh - The following file is used to delete all the network resources that were created from the previous script. This scripts takes VPC ID as the input parameter

#Instructions to run the scripts
1. Place the scripts at a desired location
2. Change permission rights of the file to 755 by executing the following command
    chmod 755 csye6225-aws-networking-setup.sh
    chmod 755 csye6225-aws-networking-teardown.sh
3. Open terminal and navigate to location where you have placed the above files
4. Execute the creation script by using ./csye6225-aws-networking-setup.sh command
5. It will create all the necessary resources. Note the VPC ID that is being generated and printed on the terminal
6. In order to delete the resources execute teardown script using ./csye6225-aws-networking-teardown.sh script
7. The above script will take VPC ID that you have noted from the above steps as input. Enter the VPC ID and press enter.
8. It will delete all the netword resources associated with the VPC ID entered.