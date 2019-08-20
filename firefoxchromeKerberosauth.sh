#!/bin/bash

####################################################################################################
#
# Description
#
#   The prupose of this script is to set Google Chrome and Mozilla Firefox to handle and correctly
#   negotiate Kerberos authentication.
#
####################################################################################################
# 
# HISTORY
#
#	-Created by Michael Sewell on June 11, 2015
#
####################################################################################################

currentUser=`ls -l /dev/console | awk {' print $3 '}`
prefExists=`cat /Users/$currentUser/Library/Application\ Support/Firefox/Profiles/*.default/prefs.js | grep "network.negotiate"`
twPrefExists=`cat /Users/$currentUser/Library/Application\ Support/Firefox/Profiles/*.default/prefs.js | grep "network.negotiate" | grep "yourRealm"`
isFirefoxRunning=`ps ax | grep "Firefox" | grep -v "+"`
# Add realm to Chrome
if [ ! -f /Users/"$currentUser"/Library/Preferences/com.google.Chrome.plist ]; then
  touch /Users/"$currentUser"/Library/Preferences/com.google.Chrome.plist
fi
defaults write /Users/"$currentUser"/Library/Preferences/com.google.Chrome AuthServerWhitelist "*.smartsheet.com"
chown "$currentUser":staff /Users/"$currentUser"/Library/Preferences/com.google.Chrome.plist