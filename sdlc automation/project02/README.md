# This Project is about Step Functions Flow.
 Note:This project is about exploring step function as prepration for project03

# Project Architecture.
![alt text](https://github.com/robudexIT/awsdevopsproject/blob/main/sdlc%20automation/project02/project02.png?raw=true)

# How Project Works:
  1. When step functions is executed,it run and pass the **(command:run)** the paramter to lambda function.
  2.Then wait for 30sec, Then run lambda function and pass the **(command: status) plus the lambaresult** of the previous lambda execution.
  3. Lambda function then check ENV_STATUS environment variable, if the value = **Sucess**, it will return 'status=Success and stepfunction end with **Success** status
  4.If  ENV_STATUS environment variable is "Failed' stepfunction end with Failed Status
  5. If  ENV_STATUS environment variable, is in InProgress it will go back to step 2. After **3 attempt** without any Success status. stepfunction end with Failed status
  

# Deployment:
  - Download project02, open lambda function and copy and paste lambda.py, make ENV_STATUS='InProgress'
  - open MyStateMachine.asl.json and replace the Resource: with your lambda function arn, open AWS Step Function,Create Statemachine and import the json file.
  
  # For Testing:
    Test1. change lambda environment varialbe ENV_STATUS="Succes", start statemachine excution with {"command":"run"} input
    Test2. change lambda environment varialbe ENV_STATUS="Failed", start statemachine excution with {"command":"run"} input
    Test3. change lambda environment varialbe ENV_STATUS="InProgress", start statemachine excution with {"command":"run"} input
