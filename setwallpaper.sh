#!/bin/bash
# currentUser=$(/bin/ls -l /dev/console | /usr/bin/awk '{print $3}')
sudo -u $currentUser /usr/local/bin/desktoppr "/Library/Application Support/Convoy/convoy.png"
