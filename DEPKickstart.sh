#!/bin/bash

touch /var/db/.DEP_Done
sudo jamf recon
sudo profiles renew -type enrollment