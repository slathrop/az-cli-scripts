#!/bin/bash
#
# Execute this directly in Azure Cloud Shell (https://shell.azure.com) by pasting (SHIFT+INS on Windows, CTRL+V on Mac or Linux)
# the following line (beginning with curl...) at the command prompt (uses shortened URL to this script as committed in GitHub repo):
#
#   curl https://git.io/slathrop-az-hello-arg | bash -sL <YourFirstNameArg>
#

echo Hello $1!
echo Your Azure Subscriptions are as follows...
az account list
