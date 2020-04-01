az account set --subscription $1
echo "Updating storage lifecycle management policy"
echo "Move to Cold storage after 360 days"
az storage account management-policy create --resource-group $2 --account-name $3 --policy '{"rules":[{"enabled":true,"name":"move-to-cold-storage-after-360-days","type":"Lifecycle","definition":{"actions":{"baseBlob":{"tierToCool":{"daysAfterModificationGreaterThan":360}}},"filters":{"blobTypes":["blockBlob"]}}}]}'
