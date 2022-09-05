# This Project dynamically allocates the software licenses to the application servers upon creation
Note: This Project is created in Region: us-west-2/Oregon.

AWS Sevices Used:
- AutoScaling Group
- S3 
- Dynamodb
- Lambda
- Cloudwatch Event

# How Project Works:
  When EC2 launches via AutoScaling Group it will Automaically get the license-key on Dynamodb, (For simplicity License key is add as Tag on the instance) and mark this key as used.
  Autoscaling has lifecyclehook with Instance Terminate.
  CloudWatch Event listen to this hook and trigger lambda function upon this lifecyclehook
  Lambda function then update license key used by terminated Instance back to unsed.
  
  
  
For Follow-Along:
  - Create IAM role for EC2  name 'ec2-role' and  allow acces to EC2 S3 and Dynamodb For simplicity, used the fullAccess options on each service. 
  - Create Dynamodb table 'license_key_db' with key as primary key, populate atleast 5 items on the table with random strings as a key and add used attribute names with Bolean types and with value of False.
  - Create S3 Bucket name of your choice and must be unique. updatethe bucket name portion of the userdata.sh script. 
        - /bin/aws s3 cp s3://your-bucket-name/getkey.py  .
  - Upload the getkey.py located on this project on your newly created bucket
  - Create Launch Configuration with following settings
       - AMI = ami-0c2ab3b8efb09f272
       - Instance type = t2.micro
       - IAM instance profile = ec2-role 
       - Security Group - create new
       - Key pair - your Keypair
       - On Advance Details, Look for User Data and paste userdata.sh located on this project 
       - Click Create Launch Configuration
  - Create AutoScling Groupt name 'asg1'
      - Choose Default VPC and Select All AZs
      - No loadbalancer
      - HealthCheck = EC2
      - Group Size
          Minimum = 1
          Disired= 1
          Maximum = 3
      - Leave Everything Defaults and Create AutoScaling
      - After Autoscaling was created, Click Instance Management tab and add LifecycleHook named 'before_terminate' , Lifecycle transition='Instance Terminate' Default Result = 'ABANDON' 
  - Select the EC2 Instance and Locate the Tags. Check if there is 
      - license_key	"your_random_string' on the tags
  - Open your dynamodb table and confirm if that key ramdom string is set in to True.
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
  - Terminate the Instance to Test. After Instance was terminate check the Dynamodb Table and check the key randaom_string set back to false or it back to unused
  - After Lab..Please Delete/Terminate All used Services.
  - 
