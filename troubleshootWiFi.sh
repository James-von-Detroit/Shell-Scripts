#!/bin/bash

####################################################################################################
#
# Description
#
#   The purpose of this script is to provide basic troubleshooting for Wi-Fi by power cycling the
#   internal Wi-Fi card.
#
####################################################################################################
# 
# HISTORY
#
#	-Created by Michael Sewell on March 25, 2015
#
####################################################################################################

# get current wifi device
CURRENT_DEVICE=$(networksetup -listallhardwareports | awk '$3=="Wi-Fi" {getline; print $2}')
echo "Current Wi-Fi Device = '$CURRENT_DEVICE'"

# turn off wifi
networksetup -setairportpower $CURRENT_DEVICE off

# turn on wifi
networksetup -setairportpower $CURRENT_DEVICE on