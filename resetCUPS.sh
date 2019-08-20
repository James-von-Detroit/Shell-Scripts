#!/bin/bash

####################################################################################################
#
# Description
#
#   The purpose of this script to to provide basic troubleshooting of the print system by removing
#   all currently mapped devices. This is used in conjuction with remapping all network printers in
#   the JSS via policy.
#
####################################################################################################
# 
# HISTORY
#
#	-Created by Michael Sewell on March 25, 2015
#
####################################################################################################

## Reset Printer System 
lpstat -p | cut -d' ' -f2 | xargs -I{} lpadmin -x {} 
echo "Printer System Reset"
exit 0