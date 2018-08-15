#!/bin/bash
#
# Execute this directly in Azure Cloud Shell by pasting (SHIFT+INS on Windows, CTRL+V on Mac or Linux)
# this command (uses shortened URL):
#
#   bash <(curl -sL https://git.io/slathrop-az-hello-you)
#

read -p "Enter your first name: " fname

echo Hello $fname!
echo Your Azure Subscriptions are as follows...
az account list
