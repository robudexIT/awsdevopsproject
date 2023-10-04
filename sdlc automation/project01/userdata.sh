#!/bin/bash

#update the system
yum update -y
yum install git -yum

#Install latest boto3
/bin/python3 -m pip install boto3


#Install requests module
/bin/python3 -m pip install requests

#clone the github repo project
cd /tmp
git clone https://github.com/robudexIT/awsdevopsproject.git

#Run the script
/bin/python3 /tmp/awsdevopsproject/sdlc\ automation/project01/getkey.py
