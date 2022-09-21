#!/bin/bash

#update the system
/bin/yum update -y

#Install latest boto3
/bin/python3 -m pip install boto3


#Copy the script from s3 bucket to current directory
/bin/aws s3 cp s3://your-bucket-name/getkey.py  .

#Install requests module
/bin/python3 -m pip install requests

#Run the script
/bin/python3 getkey.py
