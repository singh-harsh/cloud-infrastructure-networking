# csye6225-fall2018

Team member info-
1. Annie Joseph - joseph.anni@husky.neu.edu
2. Hardik Jain - jain.h@husky.neu.edu
3. Harsh Singh - singh.har@husky.neu.edu
4. Shruti Shetty - shetty.shru@husky.neu.edu

# Prerequisites for building and deploying application locally
## Software requirements
1. IntelliJ -To run application
2. Postman -Tool for testing the HTTP request
3. PostgreSQL -Database for User 
## Packages required
1. Spring Boot
2. Hibernate
3. RestAssured
4. Spring boot Test
5. jUnit

# Build and Deploy instructions for web application
1. Open **cloud-application** in IntelliJ
2. Open **CloudApplictaionMain** file and run
3. Open Postman and test the below mentioned end-points
   **End-points**
   1. GET http://localhost:8080/
   		Use basic auth and provide username and password to get success response as current datetime.
   2. POST http:/localhost:8080/user/register
   		Provide email and password to verify if email address is already present else create new user.

# Instructions to run unit, load tests
1. Go to **UserLoginTest** file and run the test-cases