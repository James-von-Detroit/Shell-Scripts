#!/bin/sh
# Apple approved way to get the currently logged in user (Thanks to Froger from macadmins.org and https://developer.apple.com/library/content/qa/qa1133/_index.html)
ConsoleUser="$(/usr/bin/python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')"

# Install Homebrew as the currently logged in user
sudo -H -u $ConsoleUser brew tap caskroom/cask  </dev/null	