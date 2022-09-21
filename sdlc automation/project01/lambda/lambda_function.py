import json
import boto3
import requests
from botocore.config import Config
from boto3.dynamodb.conditions import  Attr
my_config = Config(
        region_name = 'us-west-2'
)

dynamodb = boto3.resource('dynamodb', config=my_config)

table = dynamodb.Table('license_key_db')



def lambda_handler(event, context):
    # TODO implement
    print(event)
    EC2InstanceId = event['detail']['EC2InstanceId']
    token = event['detail']['LifecycleActionToken']
    client = boto3.client('ec2', config=my_config)


    response = client.describe_instances(
          Filters=[
            {
                'Name':'instance-id',
                'Values': [EC2InstanceId]
            },
        ],  
        InstanceIds=[
            EC2InstanceId 
        ],
        DryRun=False,
        
    )
 
    # license_key = response['Reservations'][0]['Instances'][0]['Tags'][1]['Value']
    tag_list = response['Reservations'][0]['Instances'][0]['Tags']
    license = ''
    for tag in tag_list:
        if(tag['Key'] == 'license_key'):
            license = tag
            break
    if(type(license) is dict):    
        update_item = table.update_item(
            Key ={
            'key': license['Value'],
            },
        UpdateExpression='SET used = :val',
            ExpressionAttributeValues={
            ':val': False
            }
       )  

    client = boto3.client('autoscaling', config=my_config)
    
    
    response = client.complete_lifecycle_action(
        LifecycleHookName=' ',
        AutoScalingGroupName='asg1',
        LifecycleActionResult='CONTINUE',
        InstanceId=EC2InstanceId,
        LifecycleActionToken=token
        
    )
    return {
        'statusCode': 200,
        'body': json.dumps('Function Executed')
    }
