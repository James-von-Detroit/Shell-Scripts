#!/bin/bash

####################################################################################################
#
# Description
#
#   The purpose of this script is to add the current logged in user admin creds for that machine.
#
####################################################################################################
# 
# HISTORY
#
#	-Created by Michael Sewell on June 15, 2016
#
####################################################################################################

# Get username of current logged in user
USERNAME=`/bin/ls -l /dev/console | /usr/bin/awk '{ print $3 }'`

# give current logged user admin rights
sudo dseditgroup -o edit -a $USERNAME -t user admin
exit 0