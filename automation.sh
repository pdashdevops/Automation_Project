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


#Creare inventory file

LOGTYPE="Log Type"
DATE="Date Created"
Logtype1=$(ls -lt /tmp | grep httpd | head -1 |awk {'print $9'} | awk -F "-" {'print $2"-"$3'})
Type=$(ls -lt /tmp | grep httpd | head -1 | awk {'print $9'} | awk -F "." {'print $2'})
Date1=$(ls -lt /tmp | grep httpd | head -1 | awk {'print $9'} | awk -F "." {'print $1'}| awk -F "-" {'print $4"-"$5'})
Size=$(ls -lth  /tmp | grep httpd | head -1 |awk {'print $5'})
if [ -f "/var/www/html/inventory.html" ]
then
printf "<p>" >> /var/www/html/inventory.html
printf  "$Logtype1 $Date1 $Type $Size" >> /var/www/html/inventory.html
printf "<p>" >> /var/www/html/inventory.html
else
touch /var/www/html/inventory.html
printf "%s\t" "$LOGTYPE" "$DATE"  "Type" "Size" >> /var/www/html/inventory.html
printf "<p>" >> /var/www/html/inventory.html
printf  "$Logtype1 $Date1 $Type $Size" >> /var/www/html/inventory.html
printf "<p>" >> /var/www/html/inventory.html
fi

#Add the cron job

if [ -f "/etc/cron.d/automation" ];
then
        echo "Automation script in place for Daily 00:00 hrs"
else
        touch /etc/cron.d/automation
        printf "0 0 * * * root /root/Automation_Project/auotmation.sh" > /etc/cron.d/automation
fi
