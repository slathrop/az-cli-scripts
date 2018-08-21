#!/bin/bash
#
# Execute this directly in Azure Cloud Shell (https://shell.azure.com) by pasting (SHIFT+INS on Windows, CTRL+V on Mac or Linux)
# the following line (beginning with curl...) at the command prompt (uses shortened URL to this script as committed in GitHub repo)
# and then replacing the args:
#
#   <FirstArg>
#
#   curl -sL https://git.io/slathrop-az-aks | bash -s <FirstArg>
#

echo Hello $1!
echo Your Azure Subscriptions are as follows...
az account list
