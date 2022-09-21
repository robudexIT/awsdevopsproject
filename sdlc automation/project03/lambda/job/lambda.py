import os
import json
import boto3

# env variables
SSM_DOCUMENT_NAME = os.environ['SSM_DOCUMENT_NAME']
SSM_DOCUMENT_VERSION = os.environ['SSM_DOCUMENT_VERSION']

print('Loading function')
ssm = boto3.client('ssm')

COMMAND_RUN = 'run'
COMMAND_STATUS = 'status'

def lambda_handler(event, context):
    # Log the received event
    print("Received event: " + json.dumps(event, indent=2))

    try:
        # Get parameters from the event
        command = event['command']

        if command == COMMAND_RUN:
            return start_automation(event)
        elif command == COMMAND_STATUS:
            return check_automation_status(event)
        else:
            raise Exception('Unknown command')

    except Exception as e:
        print(e)
        raise Exception('Error processing a job')


def start_automation(event):
    # Get parameters from the event
    documentName = SSM_DOCUMENT_NAME
    documentVersion = SSM_DOCUMENT_VERSION
    # Send command to the builder instance
    response = ssm.start_automation_execution(
    DocumentName=documentName,
    DocumentVersion=documentVersion
    )

    # extract  AutomationExecutionId
    automationExecutionId = response['AutomationExecutionId']

    return {
        'automationExecutionId': automationExecutionId,
        'status': 'InProgress'
    }


def check_automation_status(event):
    # Get parameters from the event
   automationExecutionId = event['automationExecutionId']
   
   response = ssm.get_automation_execution(
     AutomationExecutionId=automationExecutionId
   )

   automationExecutionStatus = response['AutomationExecution']['AutomationExecutionStatus']
   

   return {
        'automationExecutionId': automationExecutionId,
        'status': automationExecutionStatus
   }

   
