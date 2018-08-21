#!/bin/bash
#
# Execute this directly in Azure Cloud Shell (https://shell.azure.com) by pasting (SHIFT+INS on Windows, CTRL+V on Mac or Linux)
# the following line (beginning with curl...) at the command prompt (uses shortened URL to this script as committed in GitHub repo)
# and then replacing the args:
#
#   <namingPrefix>      Prefix for all names
#   <suiteName>         Name/abbrev. of suite of services
#   <cspPwd>            Cluster Service Principle Password
#
#   curl -sL https://git.io/slathrop-az-aks | bash -s <namingPrefix> <suiteName> <cspPwd>
#

echo Hello $1 $2 $3!
echo Your Azure Subscriptions are as follows...
az account list
