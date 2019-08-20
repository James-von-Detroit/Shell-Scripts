#!/bin/bash

####################################################################################################
#
# Description
#
#   The purpose of this script is to remove all files associated with Office 2016 for Mac in order
#   to perform a clean reinstall or upgrade.
#
####################################################################################################
# 
# HISTORY
#
#	-Created by Michael Sewell on October 1, 2015
#
####################################################################################################

osascript -e 'tell application "Microsoft Database Daemon" to quit'
	osascript -e 'tell application "Microsoft AU Daemon" to quit'
	osascript -e 'tell application "Office365Service" to quit'
	rm -R '/Applications/Microsoft Excel.app/'
	rm -R '/Applications/Microsoft OneNote.app/'
	rm -R '/Applications/Microsoft Outlook.app/'
	rm -R '/Applications/Microsoft PowerPoint.app/'
	rm -R '/Applications/Microsoft Word.app/'
	rm -R '/Library/Application Support/Microsoft/'
	rm -R /Library/Fonts/Microsoft/
	mv '/Library/Fonts Disabled/Arial Bold Italic.ttf' /Library/Fonts
	mv '/Library/Fonts Disabled/Arial Bold.ttf' /Library/Fonts
	mv '/Library/Fonts Disabled/Arial Italic.ttf' /Library/Fonts
	mv '/Library/Fonts Disabled/Arial.ttf' /Library/Fonts
	mv '/Library/Fonts Disabled/Brush Script.ttf' /Library/Fonts
	mv '/Library/Fonts Disabled/Times New Roman Bold Italic.ttf' /Library/Fonts
	mv '/Library/Fonts Disabled/Times New Roman Bold.ttf' /Library/Fonts
	mv '/Library/Fonts Disabled/Times New Roman Italic.ttf' /Library/Fonts
	mv '/Library/Fonts Disabled/Times New Roman.ttf' /Library/Fonts
	mv '/Library/Fonts Disabled/Verdana Bold Italic.ttf' /Library/Fonts
	mv '/Library/Fonts Disabled/Verdana Bold.ttf' /Library/Fonts
	mv '/Library/Fonts Disabled/Verdana Italic.ttf' /Library/Fonts
	mv '/Library/Fonts Disabled/Verdana.ttf' /Library/Fonts
	mv '/Library/Fonts Disabled/Wingdings 2.ttf' /Library/Fonts
	mv '/Library/Fonts Disabled/Wingdings 3.ttf' /Library/Fonts
	mv '/Library/Fonts Disabled/Wingdings.ttf' /Library/Fonts
	rm -R /Library/Internet\ Plug-Ins/SharePoint*
	rm -R /Library/LaunchDaemons/com.microsoft.*
	rm -R /Library/Preferences/com.microsoft.*
	rm -R /Library/PrivilegedHelperTools/com.microsoft.*
	OFFICERECEIPTS=$(pkgutil --pkgs=com.microsoft.office.*)
	for ARECEIPT in $OFFICERECEIPTS
	do
		pkgutil --forget $ARECEIPT
	done
exit 0