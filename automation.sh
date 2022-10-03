#!/bin/bash
timestamp=$(date '+%d%m%Y-%H%M%S')
my_name="Prakash"
s3_bucket="upgrad-prakash"
#Perform an update of the package details and the package list
sudo apt update -y
#Install the apache2 package if it is not already installed
PKG_INSTALLED=$(dpkg --get-selections | grep apache2 |awk 'NR==1{print $2}')
if [ "$PKG_INSTALLED" == "" ]
then
sudo apt-get install apache2
else
echo "apache2 already installed"
fi
#Ensure that the apache2 service is running. 
SERVER_STATUS=$(systemctl --type=service | grep "apache2.service" |awk {'print $4'})
if [ "$SERVER_STATUS" != "running" ]
then
sudo /etc/init.d/apache2 start
else
echo "apache2 already running"
fi
#Create a tar archive of apache2 access logs and error logs 
tar -cvf /tmp/$my_name-httpd-logs-$timestamp.tar /var/log/apache2/*.log
#The script should run the AWS CLI command and copy the archive to the s3 bucket.
aws s3 cp /tmp/$my_name-httpd-logs-$timestamp.tar s3://${s3_bucket}/${my_name}-httpd-logs-${timestamp}.tar

