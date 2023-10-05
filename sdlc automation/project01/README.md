# This Project dynamically allocates the software licenses to the application servers upon creation
Note: This Project is created in Region: us-west-2/Oregon.

AWS Sevices Used:
- AutoScaling Group
- Dynamodb
- Lambda
- Cloudwatch Event

# How Project Works:
When an EC2 instance is launched through an Auto Scaling Group, it is configured to automatically retrieve a license key from DynamoDB. For simplicity, we store the license key as a Tag on the instance. Once the instance obtains the license key, it is marked as 'used' (**used** attribute is true) in DynamoDB.

An Auto Scaling Group has a lifecycle hook attached to it for instances that are terminating. A CloudWatch Event is set up to monitor this lifecycle hook trigger, which in turn, invokes a Lambda function.

This Lambda function is responsible for updating the status of the license key in DynamoDB. Specifically, it changes the status from 'used' (**used** attribute is true)  (if the instance is terminating) back to 'unused,' (**used** attribute is false)  ensuring that the license key becomes available for future instances."

  
  
  
**Instructions for Follow-Along:**

1. Create an IAM Role for EC2 named **'ec2-role'** and grant it access to both EC2 and DynamoDB. To simplify, you can use the 'FullAccess' policy for each service.

2. Create a DynamoDB Table named **'license_key_db'** with 'key' as the primary key. Populate the table with at least 5 items, using random strings as keys, and add an attribute named "used" with Boolean type set to 'False'.

3. Clone the GitHub Repository: Clone the GitHub repository from this link (https://github.com/robudexIT/awsdevopsproject.git) and navigate to 'awsdevopsproject/sdlc automation/project01'. This directory will be your working directory for this project.

4. Create a Launch Configuration with the following settings:

- AMI: **amazon ec2 linux ami**
- Instance Type: **t2.micro**
- IAM Instance Profile: **ec2-role**
- Security Group: Create a new one
- Key Pair: Use your own Key Pair
- Advanced Details: Look for 'User Data' and paste the content of 'userdata.sh' from this project.
- Click 'Create Launch Configuration'.
- Create an Auto Scaling Group (ASG) named **'asg1**':

- Choose the default VPC and select all available Availability Zones.
- No load balancer for this setup.
- Set Health Check to 'EC2'.
- Group Size:
   - Minimum: 1
   - Desired: 1
   - Maximum: 3
- Leave all other settings as default and create the Auto Scaling Group.
- After ASG creation, navigate to the 'Instance Management' tab and add a Lifecycle Hook named 'before_terminate'. Set the Lifecycle transition to 'Instance - Terminate' and Default Result to 'ABANDON'.
6. Verify EC2 Instance Tags: Select the EC2 instance and check if there's a tag named 'license_key' with a value of 'your_random_string'.

7. Confirm DynamoDB Update: Open your DynamoDB table and confirm that the 'used' attribute for the 'your_random_string' key is set to 'True'.

8. Create a Lambda Function named **'before_terminating'** with a Python3+ runtime. Upload the 'lambda.zip' file located in this project.
9. Assign a Role to the Lambda Function to grant access to EC2 and DynamoDB. For simplicity, you can use 'FullAccess' policies for both services.

10. Create a CloudWatch Event Rule named **'ec2_terminate'** with the following settings:


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


      
**Terminate the Instance to Test:**
1. To test your setup, terminate the EC2 instance that is part of the Auto Scaling Group. You can do this manually from the AWS Management Console or by using AWS CLI commands.

2. After the instance is terminated, check the DynamoDB table **'license_key_db'**. Verify that the 'used' attribute for the 'your_random_string' key has been set back to **'False'** or 'unused.'

**Delete/Terminate All Used Services After Lab:**

 1. After you have completed your lab and verified the functionality, it's essential to clean up and terminate all the services to avoid incurring additional charges and maintain resource hygiene.

 2. Here are the steps to delete/terminate the used services:

3. Terminate the EC2 instances created by the Auto Scaling Group:
  - Navigate to the Auto Scaling Group in the AWS Management Console.
  - Select the **'asg1** Auto Scaling Group.
  - Choose the 'Instances' tab and terminate any running instances associated with this group.

4. Delete the Auto Scaling Group:
  - In the 'asg1' Auto Scaling Group page, select 'Actions' and choose 'Delete.'

5. Delete the Launch Configuration:
  - Navigate to the Launch Configurations in the AWS Management Console.
  - Select the 'Launch Configuration' you created earlier ('asg1-launch-config').
  - Choose 'Actions' and then 'Delete Launch Configuration.'
6. Delete the IAM Role **'ec2-role'**:
  - Go to the IAM service in the AWS Management Console.
  - Select 'Roles' in the left navigation pane.
  - Locate and select **'ec2-role,**' then choose 'Delete role.'
7. Delete the DynamoDB Table **'license_key_db'**:
  - Navigate to DynamoDB in the AWS Management Console.
  - Select 'Tables' on the left.
  - Find 'license_key_db,' select it, and choose 'Delete table.'
8. Delete the Lambda Function **'before_terminating'**:
  - Access the Lambda service in the AWS Management Console.
  - Select 'Functions' on the left.
  - Locate 'before_terminating,' select it, and choose 'Delete function.'
9. Remove the CloudWatch Event Rule **'ec2_terminate'**:
  - Go to the CloudWatch service in the AWS Management Console.
  - Select 'Rules' in the left navigation pane.
  - Find and select **'ec2_terminate,'** then choose 'Delete.'
10. Clean up any security groups or key pairs you may have created.

By following these steps, you can ensure that all resources used during the lab are properly terminated, preventing any ongoing charges and maintaining a clean AWS environment.

 
