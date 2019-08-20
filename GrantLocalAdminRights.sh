#!/bin/sh

# Get username of current logged in user
USERNAME=`/bin/ls -l /dev/console | /usr/bin/awk '{ print $3 }'`

# give current logged user admin rights
sudo dseditgroup -o edit -a $USERNAME -t user admin
exit 0