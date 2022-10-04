# Automation_Project
Perform an update of the package details and the package list at the start of the script.
Install the apache2 package if it is not already installed. 
Ensure that the apache2 service is running. 
Ensure that the apache2 service is enabled. 
Create a tar archive of apache2 access logs and error logs that are present in the /var/log/apache2/ directory and place the tar into the /tmp/ directory.
The script should run the AWS CLI command and copy the archive to the s3 bucket.
Ensure that your script checks for the presence of the inventory.html file in /var/www/html/; if not found, creates it. This file will essentially serve as a web page to get the metadata of the archived logs
Your script should create a cron job file in /etc/cron.d/ with the name 'automation' that runs the script /root/<git repository name>/automation.sh every day via the root user.
