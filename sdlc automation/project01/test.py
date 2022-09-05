Ec2InstanceId = 'rogmer'

print(Ec2InstanceId )
   
event = {'version': '0', 'id': '2ea47568-bf55-0e6c-93e7-d1cde8401ef8', 'detail-type': 'EC2 Instance-terminate Lifecycle Action', 'source': 'aws.autoscaling', 'account': '065741252821', 'time': '2022-09-02T18:55:19Z', 'region': 'us-west-2',
 'resources': ['arn:aws:autoscaling:us-west-2:065741252821:autoScalingGroup:838c3e91-80d8-4f26-9218-97f22a76cde1:autoScalingGroupName/asg1'], 
 'detail': {'LifecycleActionToken': '98ac5238-bc63-47cc-bdf0-421dab0a74e7', 'AutoScalingGroupName': 'asg1', 'LifecycleHookName': 'before_terminate', 'EC2InstanceId': 'i-031b07612a6f8e72a', 'LifecycleTransition': 'autoscaling:EC2_INSTANCE_TERMINATING', 'Origin': 'AutoScalingGroup', 'Destination': 'EC2'}
 }

response = {'Reservations':[{'Instances':[{'Tags':[{'Key': 'Key1', 'Value': 'val1'},{'Key':'license','Value':'JSFLJAS'}]}]}]}
tag_list = response['Reservations'][0]['Instances'][0]['Tags']

# license_key = filter(lambda tag: tag['Key'] == 'license_key', tag_list)

# key = license_key[0]
license = ''
for tag in tag_list: 
    if(tag['Key'] == 'license_key'):
        license = tag
        break

if(type(license) is dict):
    print('License found')
else:
    print('License not found')    
print(event['detail']['EC2InstanceId'])
print(event['detail']['LifecycleActionToken'])

