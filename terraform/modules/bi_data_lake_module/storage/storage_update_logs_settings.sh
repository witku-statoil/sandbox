az account set --subscription $1
echo "Updating blob logging"
echo "Subscription: "$1
echo "Resource Group: "$2
echo "Account: "$3
echo "Retention Days: "$4
az storage logging update --account-name $3 --log rwd --retention $4 --services b --version '2.0'
