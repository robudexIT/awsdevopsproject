#!/bin/bash

#update the system and install some packages
 apt update -y
 apt install git -y
 apt install pip

#Install latest boto3
python3 -m pip install boto3


#Install requests module
python3 -m pip install requests

#clone the github repo project
cd /tmp
git clone https://github.com/robudexIT/awsdevopsproject.git

#Run the script
python3 /tmp/awsdevopsproject/sdlc\ automation/project01/getkey.py
