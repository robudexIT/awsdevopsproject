#!/bin/bash

#update the system
/bin/yum update -y

#Install latest boto3
/bin/python3 -m pip install boto3


#Install requests module
/bin/python3 -m pip install requests

#Run the script
/bin/python3 getkey.py
