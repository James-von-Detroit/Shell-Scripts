#!/bin/bash
##############
# Opens the web form for temp admin access
# michael.sewell@smartsheet.com
# June 12, 2016
##############

su - `ls -l /dev/console | awk '{print $3}'` -c "open https://app.smartsheet.com/b/form?EQBCT=8347598ffe3e4a4db966c441419f600e"