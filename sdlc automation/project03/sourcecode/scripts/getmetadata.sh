#!/bin/bash
EC2_INSTANCE_ID=$(TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: $
sed -i "s/was deployed/was deployed on $EC2_INSTANCE_ID /g" /var/www/html/index.php 
chmod 664 /var/www/html/index.php 