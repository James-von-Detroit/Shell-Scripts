#!/bin/bash
##############
# This script will give a user 30 minutes of Admin level access, from Jamf's self 
# service.
# At the end of the 30 minutes it will then call a jamf policy with a manual 
# trigger. 
# Remove the users admin rights and disable the plist file this creates and 
# activites.
# The removal script is removetempAdmin.sh
##############

USERNAME=`who |grep console| awk '{print $1}'`

# Place launchd plist to call JSS policy to remove admin rights.
#####
echo "<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>com.smartsheet.adminremove</string>
	<key>ProgramArguments</key>
	<array>
		<string>/usr/local/jamf/bin/jamf</string>
		<string>policy</string>
		<string>-event</string>
		<string>adminremove</string>
	</array>
	<key>StartInterval</key>
	<integer>1800</integer>
	<key>UserName</key>
	<string>root</string>
	<key>GroupName</key>
	<string>wheel</string>
</dict>
</plist>

" > /Library/LaunchDaemons/com.smartsheet.adminremove.plist
#####

#set the permission on the file just made.
chown root:wheel /Library/LaunchDaemons/com.smartsheet.adminremove.plist
chmod 644 /Library/LaunchDaemons/com.smartsheet.adminremove.plist
#defaults write /Library/LaunchDaemons/com.smartsheet.adminremove.plist disabled -bool false

# load the removal plist timer. 
launchctl load -w /Library/LaunchDaemons/com.smartsheet.adminremove.plist

# build log files in var/uits
mkdir /var/uits
TIME=`date "+Date:%m-%d-%Y TIME:%H:%M:%S"`
echo $TIME " by " $USERNAME >> /var/uits/30minAdmin.txt

echo $USERNAME >> /var/uits/userToRemove

# give current logged user admin rights
/usr/sbin/dseditgroup -o edit -a $USERNAME -t user admin
exit 0