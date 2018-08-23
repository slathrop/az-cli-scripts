#!/bin/bash
#
# NOTE: This script is similar to az-aks.sh, but it adds FTPS of results to your Azure Websites deployment FTP host
#
# Execute this directly in Azure Cloud Shell (https://shell.azure.com) by pasting (SHIFT+INS on Windows, CTRL+V on Mac or Linux)
# the following line (beginning with curl...) at the command prompt and then replacing the args:
#
#   curl -sL https://git.io/slathrop-az-aks-ftp | bash -s <namingPrefix> <suiteName> <adspPwd> <azureFTPSubDomain> <ftpCreds> [<location>]
#
#     [Required]  ${1}  <namingPrefix>        Prefix for all names (e.g., "prod")
#     [Required]  ${2}  <suiteName>           Name/abbrev. of suite of services (e.g., "o365")
#     [Required]  ${3}  <adspPwd>             AD Service Principal (for cluster) Password (recommend a GUID)
#     [Required]  ${4}  <azureFTPSubDomain>   Just the sub-domain portion of an FTP site of the form: "<sub-domain>.ftp.azurewebsites.windows.net"
#     [Required]  ${5}  <ftpCreds>            FTP credentials of the form: "username:password"
#     [Optional]  ${6}  <location>            Azure location. Defaults to "eastus"
#
#   For example:
#
#   curl -sL https://git.io/slathrop-az-aks-ftp | bash -s "prod" "o365" "eeeeeeee-ffff-aaaa-bbbb-cccccccccccc" "waws-prod-zzz-111" "resgrp\ftp-user:SomePassw0rd!"
#
# If necessary, cleanup and start from scratch with:
#
#   az group delete --name <namingPrefix>-<suiteName>-res-grp --yes
#
#   az ad sp delete --id "http://<namingPrefix>-<suiteName>-adsp"
#

# If not supplied, ${6} defaults to "eastus"
if [ -z "$6" ]; then
   set -- "$1" "$2" "$3" "$4" "$5" "eastus"
fi

echo "az-aks-ftp.sh - rev. 3"
echo ""
echo "This script will create (in \"${6}\"):"
echo ""
echo "  - A resource group \"${1}-${2}-res-grp\""
echo "  - A container registry \"${1}${2}containers\" using the \"Standard\" SKU"
echo "  - An Azure AD service principal \"${1}-${2}-adsp\""
echo "  - A role assignment granting the new service principal access to the container registry"
echo "  - A single-node (Standard_B2s) Kubernetes Service (AKS) cluster \"${1}-${2}-cluster\" running as the new service principal"
echo ""
echo "  Output from Azure commands is piped (appended) into a file named \"${1}-${2}-output.log\""
echo "  for later review: tail --lines=100 ${1}-${2}-output.log"
echo ""
echo "* NOTE: Final results including credentials and IDs will be sent automatically via FTPS"
echo "  to a dropbox specified by the engineer that asked you to execute this command"
echo "  so that they may administer the new cluster."
echo ""
echo "  Total Execution Time: ~20 minutes. Press CTRL+C now if you wish to exit cleanly."

echo ""
read -es -p "Press ENTER to continue." TRAP_ENTER_KEY < /dev/tty

echo ""
echo " - Running .."

# Create resource group
az group create --location ${6} --name ${1}-${2}-res-grp >> ${1}-${2}-output.log

# Create container registry (acr)
az acr create --name ${1}${2}containers --resource-group ${1}-${2}-res-grp --sku Standard --admin-enabled true >> ${1}-${2}-output.log

# Get acr id
export ACR_ID=$(az acr show --name ${1}${2}containers --query "id" --output tsv)

# Get acr loginServer URI... uncomment if you wish to use this for something
# export ACR_URI=$(az acr show --name ${1}${2}containers --query "loginServer" --output tsv)

# Create AD service principal (adsp)
# For a more restrictive account, consider adding: --skip-assignment
az ad sp create-for-rbac -n "${1}-${2}-adsp" -p "${3}" >> ${1}-${2}-output.log

# Get adsp appId
export SP_APP_ID=$(az ad sp show --id "http://${1}-${2}-adsp" --query "appId" --output tsv)

# Grant adsp access to acr
az role assignment create --assignee "${SP_APP_ID}" --role Owner --scope $ACR_ID >> ${1}-${2}-output.log

# Create aks cluster
az aks create --name ${1}-${2}-cluster --resource-group ${1}-${2}-res-grp --node-count 1 --generate-ssh-keys --service-principal "${SP_APP_ID}" --client-secret "${3}" --node-vm-size Standard_B2s --enable-addons http_application_routing --kubernetes-version 1.10.3 >> ${1}-${2}-output.log

# Write/merge kube config to file: .kube/config
az aks get-credentials --resource-group ${1}-${2}-res-grp --name ${1}-${2}-cluster >> ${1}-${2}-output.log

# FTPS kube config and output files to location provided by engineer in command args
curl -s --upload-file .kube/config ftps://${4}.ftp.azurewebsites.windows.net/kube-config-${1}-${2}-cluster --user "${5}"
curl -s --upload-file ${1}-${2}-output.log ftps://${4}.ftp.azurewebsites.windows.net --user "${5}"

# Echo final message
echo ""
echo "Script Execution Completed! Thank you."
echo ""
echo "* Results have been sent via FTPS to your engineer."
echo ""
