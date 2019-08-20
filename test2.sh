#!/bin/bash

# Check for macOS version
osvers=$(/usr/bin/sw_vers -productVersion | awk -F. '{print $3}')
echo $osvers