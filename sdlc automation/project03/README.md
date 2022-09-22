# This Project is using Codepipeline Custom Action to created updated and fully patched linuxAMI,

Note: This Project is created in Region: us-west-2/Oregon.
Note: This Project is based on  https://github.com/aws-samples/aws-codepipeline-custom-action. I changes and remove all codes that not relevant on this project. As an aspirant DevOPS Engineer, Its really good to know that we have some reference to someone that smarter than us and apply it to our own project.

AWS Sevices Used:
- System Manager ParameterStore
- System Manager Automation
- Lambda 
- CodePipeline
- CodeCommit
- CodeDeploy
- S3
- CloudFormation
- Cloudwatch Event
- EC2 Instance

# Project Architecture:

![alt text](https://github.com/robudexIT/awsdevopsproject/blob/main/sdlc%20automation/project03/project03.png?raw=true)

# How Project Works:
    1. As part of the pipeline, when there's a commit on the codecommit repository masterbranch, its trigger pipeline to execute the changes
    2. An Amazon CloudWatch Event triggers an AWS Lambda function when a custom CodePipeline action is to be executed.
    3.The Lambda function starts a Step Functions state machine that carries out the build job execution, passing all the gathered information as input   payload.
    4.The Step Functions flow starts an AWS Systems Manager Automation. The Step Functions flow is also responsible for handling all the errors during build job execution
    5.The Systems Manager Automation which runs by lambda functions, start an awslinux instance, apply patch and update. stop the instance,create updatedAMI, terminate the instance, and trigger lambda function to udate the parameter store with the new ami-id.
    6. Polling Lambda updates the state of the custom action in CodePipeline once it detects that the Step Function flow is completed.
   
# Deployment:
    1. System Manager:
        - Paramater Store:
           - Create two paramaters one for sourceAMI and one for the latestAMI.
             For the source parameter:
                -  aws ssm put-parameter --name "/GoldenAMI/Linux/Amazon/source" --type "String"  --value "ami-0c2ab3b8efb09f272" --region us-west-2 
             For the latest parameter:
                -  aws ssm put-parameter --name "/GoldenAMI/Linux/Amazon/latest" --type "String"  --value "ami-0c2ab3b8efb09f272" --region us-west-2
             Go to AWS System Parameter Store to check or to it in CLI using this command:
                - aws ssm get-parameters --names /GoldenAMI/Linux/Amazon/source /GoldenAMI/Linux/Amazon/latest --region us-west-2 
                
        - Automation Create Document 
            1. Creating Roles used for Automations using cloudformation
                aws cloudformation create-stack --stack-name automationrolestack --template-body file://AWS-SystemsManager-AutomationServiceRole.yaml --  capabilities CAPABILITY_NAMED_IAM --region us-west-2 
            2.Creating System Manager Automation Document:
            `   aws ssm create-document --content file://automationdocument.json --document-format JSON --name GoldenUpdatedLinuxAmi --document-type Automation --region us-west-2 

         
                
      
            

     


