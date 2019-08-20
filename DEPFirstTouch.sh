#!/bin/bash
#
#First up! Even if the machine's sitting at a login prompt. Install DepNotify

#jamf policy -event install_depnotify
#jamf policy -event install_dockutil

#figure out when the dock is showing and start script! (I'm not too sure how this works...)
# while true;	do
# 	myUser=$(whoami)
# 	dockcheck=`ps -ef | grep [/]System/Library/CoreServices/Dock.app/Contents/MacOS/Dock`
# 	echo "Waiting for file as: ${myUser}"
# 	sudo echo "Waiting for file as: ${myUser}" >> /var/log/jamf.log
# 	echo "regenerating dockcheck as ${dockcheck}."

# 	if [ ! -z "${dockcheck}" ]; then
# 		echo "Dockcheck is ${dockcheck}, breaking."
# 		break
# 	fi
# 	sleep 1
# done

#Figure out who our user is
user=$(python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')


#### Functions
#lets remove desktop icons!
#su -l $user -c "defaults write /Users/$user/Library/Preferences/com.apple.finder InterfaceLevel simple"
#killall Finder
#su -l $user -c "/usr/local/bin/dockutil --remove all"

### Define Log Files file
depnotify_log="/var/tmp/depnotify.log"
log_path="/var/log/SS_DEP.log"
#create logger
function log (){
  datetime=$(date +"%Y-%m-%d %H:%M:%S")
  echo "$datetime" - "$1" >> $log_path
}

#create depnotify log
function depnotify() {
	echo $1 >> $depnotify_log
	log "$1"
}


touch $log_path





#### SCRIPT

#log start time
start=$SECONDS

#Configure Dep notify
depnotify "Command: WindowStyle: NotMovable"
depnotify "Command: WindowStyle: ActivateOnStep"
depnotify "Command: WindowTitle: Welcome to Convoy!"
depnotify "Command: MainText: Hey there! We're doing some initial tasks on your Mac to get you started. This should only take a few minutes, so sit back grab some ☕ and wait for the magic to happen. At the end this computer will logout and ask you to enter your password to enable FileVault. \n \n Please do not close the computer or shut it down until we're finished."


#grab Convoy logo!
#curl -o /var/tmp/yourlogo.icns <url for logo>
#depnotify "Command: Image: /var/tmp/yourlogo.icns"

#Open DepNotify
/Applications/Utilities/DepNotify.app/Contents/MacOS/DEPNotify &


log "process started"


log "starting tasks"
log "our user is $user"
depnotify "Command: Determinate: 7"
log "flushing policy history"
jamf flushPolicyHistory

depnotify "Status: Getting ready..."
log "Downloading wallpaper and Desktoppr"
jamf policy -event dep_cache_wallpaper

depnotify "Status: Naming Machine"
log "providing username for recon"
jamf recon -endUsername "$user"

log "Setting computer name"
jamf policy -event dep_compname

# ### adding for future touchbar support it's safe to assume they aren't running a 
# # touchbar testing tool at this stage. 
# if pgrep "TouchBarAgent"; then
#     touch_bar="Yes"
# else
# 	touch_bar="No"
# fi

# log "Does this mac have a touchbar?: $touch_bar"

#set the hostname

# echo "Grabbing serial number"
# COMP_NAME=$(ioreg -c IOPlatformExpertDevice -d 2 | awk -F\" '/IOPlatformSerialNumber/{print $(NF-1)}')

# # Ensures complaint with NETBIOS 15 char limit
# COMP_NAME=${COMP_NAME:0:15}

# log "computer name is $COMP_NAME"

# jamf setComputerName -name "$COMP_NAME"
# /usr/sbin/scutil --set LocalHostName "$COMP_NAME"
# /usr/sbin/scutil --set HostName "$COMP_NAME"
# /usr/sbin/scutil --set ComputerName "$COMP_NAME"
# /usr/bin/defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName "$COMP_NAME"

log "finished setting computer name"
#log "setting sw update"

#depnotify "Status: Configuring Software update"
# set softwareupdate schedule On
#softwareupdate --schedule on

depnotify "Status: Installing Google Chrome"
jamf policy -event dep_install_googlechrome

depnotify "Status: Installing Zoom"
jamf policy -event dep_install_zoom

# depnotify "Stauts: Installing Notion"
# jamf policy -event dep_install_notion

depnotify "Status: Setting Wallpaper"
log "Setting wallpaper with Desktoppr"
/usr/local/bin/desktoppr "/Library/Application Support/Convoy/convoy.png"
echo Wallpaper set

log "enabling encryption"

depnotify "Status: Finishing up"
log "Clearing default dock items"
jamf policy -event dock_clear
log "Setting app icons in dock"
jamf policy -event dock_icons
log "jobs done telling machine to log user out."

touch /var/db/.DEP_Done
jamf recon
duration=$(( SECONDS - start ))

((sec=duration%60, duration/=60, min=duration%60, hrs=duration/60))
timestamp=$(printf "%d:%02d:%02d" $hrs $min $sec)

log "process took $timestamp to finish"

#lets change finder back to a happy state...
su -l $user -c "defaults write /Users/$user/Library/Preferences/com.apple.finder InterfaceLevel standard"
#touching file for future purposes.

depnotify "Command: Logout: Please click logout now to enable FileVault."
exit 0