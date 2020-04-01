az account set --subscription $1
echo "Updating storage lifecycle management policy"
echo "Delete after 60 days"
az storage account management-policy create --resource-group $2 --account-name $3 --policy '{"rules":[{"enabled":true,"name":"delete-after-60-days-policy","type":"Lifecycle","definition":{"actions":{"baseBlob":{"delete":{"daysAfterModificationGreaterThan":60}}},"filters":{"blobTypes":["blockBlob"]}}}]}'
