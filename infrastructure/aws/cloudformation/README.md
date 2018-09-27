# Description
1. csye6225-cf-networking.json - This is the Json file used to setup the required networking resources.
2. csye6225-aws-cf-create-stack.sh - Script is used to create a stack with the requried networking resources in the json file.
3. csye6225-aws-cf-terminate-stack.sh - Script is used to terminate the stack which itself terminate all the networking resources linked to the stack.

# Instructions to run the scripts
1. Keep the script files and the json file in the same location.
2. Open the terminal and navigate to the location where files are present.
3. In the terminal use below command to run the create script,
   **./csye6225-aws-cf-create-stack.sh**
4. Above command will ask for the stack name input, enter the stack name of your choice and press enter.
5. The script will show the progress of stack creation and the network resources.
6. Script will show the apropriate message to the user for successfully creation or failure in creation of the stack.
7. Once the stack is created successfully, and if it is required to terminate, just run the terminate script using below command,
  **./csye6225-aws-cf-terminate-stack.sh**
8. The above command will delete the stack and its associated netowrking resources and will show the apporpriate message for successful deletion or failure.
