#!/bin/sh
# Intended for use in Jamf Self Service. Removes and reapplies the SecureToken in order to resync the FV password.
# Created By: Michael Sewell 2018-12-11
userName="$3"
adminUser="$4"
adminPassword="$5"
adminPassword2="$6"
# Uses AppleScript to prompt the currently logged in user for their account password.
userPassword=$(/usr/bin/osascript << EOT
tell application "System Events"
activate
display dialog "Enter your current (new) login password:" with title "Resync FileVault password with Mac login password" default answer "" buttons {"Continue"} default button 1 with hidden answer
if button returned of result is "Continue" then
set pwd to text returned of result
return pwd
end if
end tell
EOT)
# Confirm the password is correct before continuing!
pwdcheck=$(dscl . authonly $userName $userPassword)
pwdcheckfail=$(echo $pwdcheck | grep 'Failed' | wc -l)
if [ $pwdcheckfail -ne 0 ]; then
    echo "Caught wrong password"
    pwdfail=$(/usr/bin/osascript << EOT
    tell application "System Events"
    activate
    display dialog "That was not your current Mac login password. Rerun to try again." with title "Resync failed" buttons {"OK"} default button 1
    return "WrongPwd"
    end tell
    EOT)
    exit 1
fi
# Check which admin password is correct.
dscl . authonly $adminUser $adminPassword
if [ $? -ne 0 ]; then 
	echo "Admin password 1 incorrect."
	exit 1
	dscl . authonly $adminUser $adminPassword2
		if [ $? -ne 0 ]; then
			echo "Admin password 2 incorrect."
			exit 1
		else 
			rightadminuser=$adminUser
			rightadminpwd=$adminPassword2
		fi
else 
	echo "Valid admin credentials found."
	rightadminuser=$adminUser
	rightadminpwd=$adminPassword
fi 

# Disables SecureToken for the currently logged in user account - try 1 with admin creds.
res=$(sysadminctl -adminUser $rightadminUser -adminPassword $rightadminpwd -secureTokenOff $userName -password $userPassword 2>&1)

# Reassign the SecureToken
res=$(sysadminctl -adminUser $rightadminuser -adminPassword $rightadminpwd -secureTokenOn $userName -password $userPassword 2>&1)
echo "Reassignment: $res"
# Update the preboot role volume's subject directory.
diskutil apfs updatePreboot /
# Confirm to user
done=$(/usr/bin/osascript << EOT
tell application "System Events"
activate
display dialog "Password resync complete. We recommend rebooting to confirm." with title "Resync complete" buttons {"OK"} default button 1
return "Done"
end tell
EOT)