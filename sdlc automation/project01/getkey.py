#!/bin/python3
import boto3
from botocore.config import Config
import requests

response = requests.get('http://169.254.169.254/latest/meta-data/instance-id')

instance_id = response.text

from boto3.dynamodb.conditions import  Attr

my_config = Config(
	region_name = 'us-west-2'
)
dynamodb = boto3.resource('dynamodb', config=my_config)

table = dynamodb.Table('license_key_db')

response = table.scan(
        
	FilterExpression=Attr('used').eq(False)
)


if not response['Items']:
	print('List is empty')
	exit()

key = response['Items'][0]['key']

print(key)

client = boto3.client('ec2', config=my_config)
#instance = ec2.Instance(instance_id)
tag = client.create_tags(
    DryRun=False,
    Resources=[
        instance_id,
    ],
    Tags=[
        {
            'Key': 'license_key',
            'Value': key
        },
    ]
)

print(tag)

response = table.update_item(
	Key ={
	 'key': key,
	},
	UpdateExpression='SET used = :val',
   	ExpressionAttributeValues={
        ':val': True
   	 }			
)
with open('license_key', 'w') as f:
    f.write(key)
    f.close()
