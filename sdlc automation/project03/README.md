# This Project is using Codepipeline Custom Action to created updated and fully patched linuxAMI,

Note: This Project is created in Region: us-west-2/Oregon.And
 This Project is based on  https://github.com/aws-samples/aws-codepipeline-custom-action. I changes and remove all codes that not relevant on this project. As an aspirant DevOPS Engineer, Its really good to know that we have some reference to someone that smarter than us and apply it to our own project.

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

![alt text](https://github.com/robudexIT/awsdevopsproject/blob/main/sdlc%20automation/project03/images/project03.png?raw=true)

# How Project Works:
    1. As part of the pipeline, when there's a commit on the codecommit repository masterbranch, its trigger pipeline to execute the changes
    2. An Amazon CloudWatch Event triggers an AWS Lambda function when a custom CodePipeline action is to be executed.
    3.The Lambda function starts a Step Functions state machine that carries out the build job execution, passing all the gathered information as input   payload.
    4.The Step Functions flow starts an AWS Systems Manager Automation. The Step Functions flow is also responsible for handling all the errors during build job execution
    5.The Systems Manager Automation which runs by lambda functions, start an awslinux instance, apply patch and update. stop the instance,create updatedAMI, terminate the instance, and trigger lambda function to udate the parameter store with the new ami-id.
    6. Polling Lambda updates the state of the custom action in CodePipeline once it detects that the Step Function flow is completed.
   
# Deployment:
    Download and cd to project03 run the command below:
    1. System Manager:
        - Paramater Store:
           - Create two paramaters one for sourceAMI and one for the latestAMI.
             For the source parameter:
                -** aws ssm put-parameter --name "/GoldenAMI/Linux/Amazon/source" --type "String"  --value "ami-0c2ab3b8efb09f272" --region us-west-2 **
             For the latest parameter:
                -  **aws ssm put-parameter --name "/GoldenAMI/Linux/Amazon/latest" --type "String"  --value "ami-0c2ab3b8efb09f272" --region us-west-2**
             Go to AWS System Parameter Store to check or to it in CLI using this command:
                - **aws ssm get-parameters --names /GoldenAMI/Linux/Amazon/source /GoldenAMI/Linux/Amazon/latest --region us-west-2** 
                
        - Automation Create Document 
            1. Creating Roles used for Automations using cloudformation
                **aws cloudformation create-stack --stack-name automationrolestack --template-body file://AWS-SystemsManager-AutomationServiceRole.yaml --  capabilities CAPABILITY_NAMED_IAM --region us-west-2 **
            2.Creating System Manager Automation Document:
            `   **aws ssm create-document --content file://automationdocument.json --document-format JSON --name GoldenUpdatedLinuxAmi --document-type Automation --region us-west-2 **
            
        
    2.Launch WebServer using CloudFormation
    - aws cloudformation deploy --template-file cf.yml --stack-name WebStack --parameter-overrides ImageId=/GoldenAMI/Linux/Amazon/source SSHKey={yourKeypair} --capabilities CAPABILITY_IAM --region us-west-2 
       - **aws iam create-role --role-name cf-role --assume-role-policy-document file://cf_trust_policy.json** 
       - **aws iam attach-role-policy --role-name  cf-role --policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess**
      ** aws iam attach-role-policy --role-name  cf-role --policy-arn arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess**
       
    3. CICD
        - Create Codecommit Repository name (source_code(
           - **aws codecommit create-repository --repository-name MyDemoRepo --repository-description "My demonstration repository" --region us-west-2**. 
           Then upload the sourcecode to this repository.
        - Create CodeDepoly Applicaiton:
            1.Create CodeDeploy Role
                 - **aws iam create-role --role-name myCodeDeployRole --assume-role-policy-document file://codeploy_trust_policy.json** 
                 **aws iam attach-role-policy --role-name myCodeDeployRole --policy-arn arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole** 
            2. Create CodeDeploy Application and Deployement Group:
                - **aws deploy create-application --application-name MYSERVERAPPS --compute-platform Server --region us-west-2** 
                - **aws deploy create-deployment-group --application-name MYSERVERAPPS --deployment-group-name dg001  --ec2-tag-filters Key=Environment,Value=Development,Type=KEY_AND_VALUE --service-role-arn { myCodeDeployRole ARN Here} --region us-west-2**
        
        - Create The CodePipeLine Custom Action
                - **aws codepipeline create-custom-action-type --cli-input-json file://action.json --region us-west-2**
                 
         
         - Package and upload necessary resources (deployment package for lambda functions). 
             -** aws s3 mb s3://{your-deployment-bucket} --region us-west-2**
             - **aws cloudformation package --template-file template.yml --output-template-file deployment.yml --s3-bucket {your-deployment-bucket}**
             - **aws cloudformation deploy --template-file deployment.yml --capabilities CAPABILITY_NAMED_IAM --stack-name {stack-name} --parameter-overrides CustomActionProviderVersion={custom-action-version}**
          Note that you need to provide the following parameters:
           ** {stack-name}** - CloudFormation stack name
           ** {custom-action-version}** - version of the custom action (1, 2, 3, etc.). Each deployment of the custom action has to have a distinct version number.   
           **{your-deployment-bucket} ** 
       - Create CodePipeline
    
    # Goto CodePipeline Follow These Steps:
         
  ![alt text](https://github.com/robudexIT/awsdevopsproject/blob/main/sdlc%20automation/project03/images/pipe01.png?raw=true)
  
  ![alt text](https://github.com/robudexIT/awsdevopsproject/blob/main/sdlc%20automation/project03/images/pipe02.png?raw=true)
  
 ** Skip build stage**. 

  ![alt text](https://github.com/robudexIT/awsdevopsproject/blob/main/sdlc%20automation/project03/images/pipe03.png?raw=true)
  
  Review the Settings and click create pipeline button
  ![alt text](https://github.com/robudexIT/awsdevopsproject/blob/main/sdlc%20automation/project03/images/pipe12.png?raw=true)

  Notice that the pipeline start immediately at make error on the deploy stage
  That because codedeploy doesnt see any instance yet.

  ![alt text](https://github.com/robudexIT/awsdevopsproject/blob/main/sdlc%20automation/project03/images/pipe04.png?raw=true)

  Create two Stages between the Source and Deploy stage a shown in the images.
  ![alt text](https://github.com/robudexIT/awsdevopsproject/blob/main/sdlc%20automation/project03/images/pipe05.png?raw=true)

  For  Add Action in the BuildAMI Stage 
  ![alt text](https://github.com/robudexIT/awsdevopsproject/blob/main/sdlc%20automation/project03/images/pipe06.png?raw=true)
  
  For  Add Action in the createInfra Stage 
  ![alt text](https://github.com/robudexIT/awsdevopsproject/blob/main/sdlc%20automation/project03/images/pipe07.png?raw=true)
  
  ![alt text](https://github.com/robudexIT/awsdevopsproject/blob/main/sdlc%20automation/project03/images/pipe08.png?raw=true)

  Once done, click save and click the Release Change button to force the pipeline to execute.
  ![alt text](https://github.com/robudexIT/awsdevopsproject/blob/main/sdlc%20automation/project03/images/pipe10.png?raw=true)


  When you see these images, the pipeline task is done.
![alt text](https://github.com/robudexIT/awsdevopsproject/blob/main/sdlc%20automation/project03/images/sourcestage.png?raw=true)


![alt text](https://github.com/robudexIT/awsdevopsproject/blob/main/sdlc%20automation/project03/images/buildamistage.png?raw=true)

![alt text](https://github.com/robudexIT/awsdevopsproject/blob/main/sdlc%20automation/project03/images/createinfrastage.png?raw=true)


![alt text](https://github.com/robudexIT/awsdevopsproject/blob/main/sdlc%20automation/project03/images/deploystage.png?raw=true)


Open the AWS EC2 and look for the instance.
To test, copy the Instance public dnsname or public ip address.and paste it in the browser.
