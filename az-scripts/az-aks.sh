#!/bin/bash
#
# Execute this directly in Azure Cloud Shell (https://shell.azure.com) by pasting (SHIFT+INS on Windows, CTRL+V on Mac or Linux)
# the following line (beginning with curl...) at the command prompt (uses shortened URL to this script as committed in GitHub repo)
# and then replacing the args:
#
#   <namingPrefix>      Prefix for all names
#   <suiteName>         Name/abbrev. of suite of services
#   <cspPwd>            Cluster Service Principal Password
#
#   curl -sL https://git.io/slathrop-az-aks | bash -s <namingPrefix> <suiteName> <cspPwd>
#
# If necessary, cleanup and start from scratch with:
#
#   az group delete --name <namingPrefix>-<suiteName>-res-grp --yes
#
#   az ad sp delete --id "http://<namingPrefix>-<suiteName>-csp"
#

# Refs: ${1} ${2} ${3}...

# Create resource group
az group create --location eastus --name ${1}-${2}-res-grp

# Create container registry (acr)
az acr create --name ${1}${2}containers --resource-group ${1}-${2}-res-grp --sku Standard --admin-enabled true

# Get acr id
export ACR_ID=$(az acr show --name ${1}${2}containers --query "id" --output tsv)

# Create cluster (c) service principal (sp) - (csp)
# For more restrictive account, consider adding: --skip-assignment
az ad sp create-for-rbac -n "${1}-${2}-csp" -p "${3}"

# Get csp appId
export CSP_APP_ID=$(az ad sp show --id "http://${1}-${2}-csp" --query "appId" --output tsv)

# Grant csp access to acr
az role assignment create --assignee "${CSP_APP_ID}" --role Owner --scope $ACR_ID

# Create aks cluster
az aks create --name ${1}-${2}-cluster --resource-group ${1}-${2}-res-grp --node-count 1 --generate-ssh-keys --service-principal "${CSP_APP_ID}" --client-secret "${3}" --node-vm-size Standard_B2s --enable-addons http_application_routing --kubernetes-version 1.10.3

# Echo instructions on csp appId
echo "Script Execution Completed!"
echo "Send this service principal ID in an email to engineer: ${CSP_APP_ID}"
