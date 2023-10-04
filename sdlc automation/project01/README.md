# This Project dynamically allocates the software licenses to the application servers upon creation
Note: This Project is created in Region: us-west-2/Oregon.

AWS Sevices Used:
- AutoScaling Group
- S3 
- Dynamodb
- Lambda
- Cloudwatch Event

# How Project Works:
When an EC2 instance is launched through an Auto Scaling Group, it is configured to automatically retrieve a license key from DynamoDB. For simplicity, we store the license key as a Tag on the instance. Once the instance obtains the license key, it is marked as 'used' in DynamoDB.

To facilitate this process, an Auto Scaling Group has a lifecycle hook attached to it for instances that are terminating. A CloudWatch Event is set up to monitor this lifecycle hook trigger, which in turn, invokes a Lambda function.

This Lambda function is responsible for updating the status of the license key in DynamoDB. Specifically, it changes the status from 'used' (if the instance is terminating) back to 'unused,' ensuring that the license key becomes available for future instances."

  
  
  
For Follow-Along:
  - Create IAM role for EC2  named 'ec2-role' and  allow access to EC2 S3 and Dynamodb (For simplicity, use the FullAccess options on each service.) 
  - Create Dynamodb table 'license_key_db' with "key" as the primary key, populate at least 5 items on the table with random strings as a key, and add "used" attribute names with Boolean types and with the value of False.
  - Create S3 Bucket name of your choice and must be unique. update the bucket name portion of the userdata.sh script. 
      - /bin/aws s3 cp s3://your-bucket-name/getkey.py  .
  - Upload the getkey.py located on this project on your newly created bucket
  - Create Launch Configuration with the following settings
       - AMI = ami-0c2ab3b8efb09f272
       - Instance type = t2.micro
       - IAM instance profile = ec2-role 
       - Security Group - create new
       - Key pair - your Keypair
       - On Advance Details, Look for User Data and paste userdata.sh located on this project 
       - Click Create Launch Configuration
  - Create AutoScling Group name 'asg1'
      - Choose Default VPC and Select All AZs
      - No Loadbalancer
      - HealthCheck = EC2
      - Group Size
          Minimum = 1
          Disired= 1
          Maximum = 3
      - Leave Everything Defaults and Create AutoScaling
      - After Autoscaling was created, Click the Instance Management tab and add LifecycleHook named 'before_terminate', Lifecycle transition='Instance Terminate' Default Result = 'ABANDON' 
  - Select the EC2 Instance and Locate the Tags. Check if there is 
      - license_key	"your_random_string' on the tags
  - Open your Dynamodb table and confirm if that key random string is set in to True.
  - Create Lambda Function name 'before_terminating' with python3+ runtime 
  - Upload the lambda/zip file located on this project
  - Add Role to the lambda_role to access S3,EC2 and Dynamodb.For simplicity make FullAccess on Each service
  - Add CloudWatch Event Rule ' ec2_terminate' with settings:
     - EventPattern = {
                        "source": [
                          "aws.autoscaling"
                        ],
                        "detail-type": [
                          "EC2 Instance-terminate Lifecycle Action"
                        ],
                        "detail": {
                          "AutoScalingGroupName": [
                            "asg1"
                          ]
                        }
                      }
    - Target: lambda->before_terminating
  - Terminate the Instance to Test. After the Instance is terminated check the Dynamodb Table and check if the key randaom_string is set back to False or it back to unused
  - After Lab..Please Delete/Terminate All Used Services.
  - 
