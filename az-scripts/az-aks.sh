#!/bin/bash
#
# Execute this directly in Azure Cloud Shell (https://shell.azure.com) by pasting (SHIFT+INS on Windows, CTRL+V on Mac or Linux)
# the following line (beginning with curl...) at the command prompt (uses shortened URL to this script as committed in GitHub repo)
# and then replacing the args:
#
#   curl -sL https://git.io/slathrop-az-aks | bash -s <namingPrefix> <suiteName> <adspPwd>
#
#     ${1}  <namingPrefix>      Prefix for all names (e.g., "prod")
#     ${2}  <suiteName>         Name/abbrev. of suite of services (e.g., "o365")
#     ${3}  <adspPwd>           AD Service Principal (for cluster) Password (recommend a GUID)
#
#   For example:
#
#   curl -sL https://git.io/slathrop-az-aks | bash -s "prod" "o365" "eeeeeeee-ffff-aaaa-bbbb-cccccccccccc"
#
# If necessary, cleanup and start from scratch with:
#
#   az group delete --name <namingPrefix>-<suiteName>-res-grp --yes
#
#   az ad sp delete --id "http://<namingPrefix>-<suiteName>-adsp"
#

echo ""
echo "This script will create (in East US):"
echo ""
echo "  - A resource group \"${1}-${2}-res-grp\""
echo "  - A container registry \"${1}${2}containers\""
echo "  - An Azure AD service principal \"${1}-${2}-adsp\""
echo "  - A role assignment granting the service principal access to the container registry"
echo "  - A Kubernetes Service cluster \"${1}-${2}-cluster\""
echo ""
echo "  Output from Azure commands is piped (appended) into a file named \"${1}-${2}-output.log\""
echo ""
echo "* ACTION ITEM: At the end, the ID of the new AD service principal"
echo "  will be displayed with a note asking you to email it to your engineer"
echo "  so that it may be used to administer the new cluster."
echo ""
echo "  Total Execution Time: ~20 minutes. Press CTRL+C now to exit, or"

read -es -p "Press ENTER to continue." TRAP_ENTER_KEY

echo  - Running ..

# Create resource group
# az group create --location eastus --name ${1}-${2}-res-grp >> ${1}-${2}-output.log

# # Create container registry (acr)
# az acr create --name ${1}${2}containers --resource-group ${1}-${2}-res-grp --sku Standard --admin-enabled true >> ${1}-${2}-output.log

# # Get acr id
# export ACR_ID=$(az acr show --name ${1}${2}containers --query "id" --output tsv)

# # Create AD service principal (adsp)
# # For a more restrictive account, consider adding: --skip-assignment
# az ad sp create-for-rbac -n "${1}-${2}-adsp" -p "${3}" >> ${1}-${2}-output.log

# # Get adsp appId
# export SP_APP_ID=$(az ad sp show --id "http://${1}-${2}-adsp" --query "appId" --output tsv)

# # Grant adsp access to acr
# az role assignment create --assignee "${SP_APP_ID}" --role Owner --scope $ACR_ID >> ${1}-${2}-output.log

# # Create aks cluster
# az aks create --name ${1}-${2}-cluster --resource-group ${1}-${2}-res-grp --node-count 1 --generate-ssh-keys --service-principal "${SP_APP_ID}" --client-secret "${3}" --node-vm-size Standard_B2s --enable-addons http_application_routing --kubernetes-version 1.10.3 >> ${1}-${2}-output.log

# Echo instructions on adsp appId
echo ""
echo ""
echo "Script Execution Completed!"
echo "*ACTION ITEM: Send this service principal ID in an email to your engineer: ${SP_APP_ID}"
echo ""
