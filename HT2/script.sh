#!/bin/bash
set -e # Exit immediately if a simple command exits with a non-zero status
set -x # Activate debugging from here
echo "### ---=== Script started ===--- ###"
# our comment is here
echo "Please, enter proces's name: "
read processName
echo "Input ProcessName = $processName"

sudo netstat -tunapl |
awk '/'$processName'/ ''{print $5}'