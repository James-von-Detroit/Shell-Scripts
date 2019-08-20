#!/bin/bash
#Create tenable.mac account as hidden admin
jamf createAccount -username tenable.mac -realname Tenable -password ")|dkE83q#'t}Y:(0A" -home /Users/tenable.mac -admin -hiddenUser -suppressSetupAssistant
echo "Tenable account created"
#Create Tenable SSH directory and authorized_keys file. 
mkdir /Users/tenable.mac/.ssh
touch /Users/tenable.mac/.ssh/authorized_keys
chmod 644 /Users/tenable.mac/.ssh/authorized_keys
echo "Directory and key file created."
#Pipes public RSA key to authorized_keys
cat /temp/tenable.mac.pub > /Users/tenable.mac/.ssh/authorized_keys
echo "public RSA key imported."
#Clean up temp folder
rm -R /temp/
echo "Temp folder removed."
exit 0