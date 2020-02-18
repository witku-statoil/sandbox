# Data Lake

output "storage_landing_name" {
	description  = "Landing Storage Account Name"
	value = azurerm_storage_account.landing.name
}

output "storage_landing_key" {
	description  = "Landing Storage Account Key"
	value = azurerm_storage_account.landing.primary_access_key
}

output "storage_archive_name" {
	description  = "Archive Storage Account Name"
	value = azurerm_storage_account.archive.name
}

output "storage_archive_key" {
	description  = "Archive Storage Account Key"
	value = azurerm_storage_account.archive.primary_access_key
}

output "storage_curated_name" {
	description  = "Curated Storage Account Name"
	value = azurerm_storage_account.curated.name
}

output "storage_curated_key" {
	description  = "Curated Storage Account Key"
	value = azurerm_storage_account.curated.primary_access_key
}

output "storage_datascience_name" {
	description  = "Data Science Sandbox Storage Account Name"
	value = azurerm_storage_account.datascience.name
}

output "storage_datascience_key" {
	description  = "Data Science Sandbox Account Key"
	value = azurerm_storage_account.datascience.primary_access_key
}

output "storage_logs_name" {
	description  = "Logs Storage Account Name"
	value = azurerm_storage_account.logs.name
}

output "storage_logs_key" {
	description  = "Logs Sandbox Account Key"
	value = azurerm_storage_account.logs.primary_access_key
}

output "storage_backup_name" {
	description  = "Backups Storage Account Name"
	value = azurerm_storage_account.backup.name
}

output "storage_backup_key" {
	description  = "Backups Sandbox Account Key"
	value = azurerm_storage_account.backup.primary_access_key
}

output "storage_vendors_name" {
	description  = "External Vendors Storage Account Name"
	value = azurerm_storage_account.vendors.name
}

output "storage_vendors_key" {
	description  = "External Vendors Sandbox Account Key"
	value = azurerm_storage_account.vendors.primary_access_key
}

output "storage_public_name" {
	description  = "Public Storage Account Name"
	value = azurerm_storage_account.public.name
}

output "storage_public_key" {
	description  = "Public Storage Account Key"
	value = azurerm_storage_account.public.primary_access_key
}

output "storage_temp_name" {
	description  = "Temporary Storage Account Name"
	value = azurerm_storage_account.temp.name
}

output "storage_temp_key" {
	description  = "Temporary Sandbox Account Key"
	value = azurerm_storage_account.temp.primary_access_key
}