#!/bin/bash

####################################################################################################
#
# Description
#
#	The purpose of this script is to set OS X to use the SMB1 stack instead of SMB2 (NSMB). When 
#   using SMB2, OS X can have incompatibility errors when mounting Windows file shares or other non
#   SMB2 file shares.
#
####################################################################################################
# 
# HISTORY
#
#	-Created by Michael Sewell on May 19, 2014
#
####################################################################################################


#Push SMB fix to global preferences folder
echo "Fixing OS X SMB iincompatibility."
echo "[default]" >> /etc/nsmb.conf; echo "smb_neg=smb1_only" >> /etc/nsmb.conf