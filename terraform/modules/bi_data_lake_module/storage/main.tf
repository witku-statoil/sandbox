# Add backend
provider "azurerm" {
	version 					= "=1.44.0" 
	subscription_id 			= var.subscription_id
	tenant_id       			= var.tenant_id
}

# Load from variables.tf
data "azurerm_resource_group" "bi_rg_prm" {
	name     = var.bi_resource_group_prm
	#location = var.bi_location_prm
	#tags = var.tags
}

# Landing Zone
resource "azurerm_storage_account" "landing" {
	name                		= "${var.bi_env_prefix}landing001${var.bi_env_suffix}"
	resource_group_name 		= data.azurerm_resource_group.bi_rg_prm.name
	location             		= data.azurerm_resource_group.bi_rg_prm.location 
	
	account_kind 				= "StorageV2"
	account_tier         		= "Standard"
	account_replication_type 	= "LRS"
	access_tier					= "Hot"
	enable_https_traffic_only  	= "true"
	is_hns_enabled 				= "false"
	
	blob_properties {
		delete_retention_policy {
			days = "60"
		}
	}

	tags = merge(map("Comments", "Data Lake temporary Landing Zone. 60 day retention policy applied."), var.tags)

	# Updates not supported by terraform provider
	provisioner "local-exec" {
		command = "./../../modules/bi_data_lake_module/storage/storage_update_logs_settings.sh ${var.subscription_id} ${self.resource_group_name} ${self.name} 60"
	}

	provisioner "local-exec" {
			command = "./../../modules/bi_data_lake_module/storage/storage_update_policy_delete_60_days.sh ${var.subscription_id} ${self.resource_group_name} ${self.name}"
	}
}

# Default containers
resource "azurerm_storage_container" "incoming" {
	name = "incoming"
	storage_account_name  = azurerm_storage_account.landing.name
	container_access_type = "private"
}

resource "azurerm_storage_container" "processing" {
	name = "processing"
	storage_account_name  = azurerm_storage_account.landing.name
	container_access_type = "private"
}

resource "azurerm_storage_container" "rejected" {
	name = "rejected"
	storage_account_name  = azurerm_storage_account.landing.name
	container_access_type = "private"
}

resource "azurerm_storage_container" "tlog-incoming" {
	name = "incoming-tlog"
	storage_account_name  = azurerm_storage_account.landing.name
	container_access_type = "private"
}

resource "azurerm_storage_container" "tlog-processing" {
	name = "tlog-processing"
	storage_account_name  = azurerm_storage_account.landing.name
	container_access_type = "private"
}

resource "azurerm_storage_container" "tlog-rejected" {
	name = "tlog-rejected"
	storage_account_name  = azurerm_storage_account.landing.name
	container_access_type = "private"
}


# Archive Zone
resource "azurerm_storage_account" "archive" {
	name                		= "${var.bi_env_prefix}archive001${var.bi_env_suffix}"
	resource_group_name 		= data.azurerm_resource_group.bi_rg_prm.name
	location             		= data.azurerm_resource_group.bi_rg_prm.location 
	
	account_kind 				= "StorageV2"
	account_tier         		= "Standard"
	account_replication_type 	= "LRS"
	access_tier					= "Hot"
	enable_https_traffic_only  	= "true"
	is_hns_enabled 				= "false"
	
	blob_properties {
		delete_retention_policy {
			days = "360"
		}
	}

	tags = merge(map("Comments", "Data Lake persistent Archive Zone."), var.tags)
	
	# Updates not supported by terraform provider
	provisioner "local-exec" {
		command = "./../../modules/bi_data_lake_module/storage/storage_update_logs_settings.sh ${var.subscription_id} ${self.resource_group_name} ${self.name} 60"
	}

	provisioner "local-exec" {
			command = "./../../modules/bi_data_lake_module/storage/storage_update_policy_cold_360_days.sh ${var.subscription_id} ${self.resource_group_name} ${self.name}"
	}
}

# Default containers
resource "azurerm_storage_container" "archive-raw" {
	name = "archive-raw"
	storage_account_name  = azurerm_storage_account.archive.name
	container_access_type = "private"
}

resource "azurerm_storage_container" "archive-clean" {
	name = "archive-clean"
	storage_account_name  = azurerm_storage_account.archive.name
	container_access_type = "private"
}

resource "azurerm_storage_container" "archive-clean-masked" {
	name = "archive-clean-masked"
	storage_account_name  = azurerm_storage_account.archive.name
	container_access_type = "private"
}


# Curated | Data Zone
resource "azurerm_storage_account" "curated" {
	name                		= "${var.bi_env_prefix}data001${var.bi_env_suffix}"
	resource_group_name 		= data.azurerm_resource_group.bi_rg_prm.name
	location             		= data.azurerm_resource_group.bi_rg_prm.location 
	
	account_kind 				= "StorageV2"
	account_tier         		= "Standard"
	account_replication_type 	= "LRS"
	access_tier					= "Hot"
	enable_https_traffic_only  	= "true"
	# Data Lake Storage Gen 2 (Hierarchical Namespace) - only used for staging (for performance reasons) & curated (for granular access) zones
	is_hns_enabled 				= "true"
	
	# Soft Delete not supported on ADLS2 yet
	#blob_properties {
	#	delete_retention_policy {
	#		days = "360"
	#	}
	#}

	tags = merge(map("Comments", "Data Lake persistent Curated Zone using ADLS2."), var.tags)
	
	# Updates not supported by terraform provider
	provisioner "local-exec" {
		command = "./../../modules/bi_data_lake_module/storage/storage_update_logs_settings.sh ${var.subscription_id} ${self.resource_group_name} ${self.name} 60"
	}

	# Lifecycle Management not yet supported on ADLS2
	#provisioner "local-exec" {
	#		command = "./../../modules/bi_data_lake_module/storage/storage_update_policy_cold_360_days.sh ${var.subscription_id} ${self.resource_group_name} ${self.name}"
	#}
}


# Default containers
resource "azurerm_storage_container" "reference" {
	name = "reference"
	storage_account_name  = azurerm_storage_account.curated.name
	container_access_type = "private"
}

resource "azurerm_storage_container" "master" {
	name = "master"
	storage_account_name  = azurerm_storage_account.curated.name
	container_access_type = "private"
}

resource "azurerm_storage_container" "source" {
	name = "source"
	storage_account_name  = azurerm_storage_account.curated.name
	container_access_type = "private"
}

resource "azurerm_storage_container" "consolidated" {
	name = "consolidated"
	storage_account_name  = azurerm_storage_account.curated.name
	container_access_type = "private"
}

resource "azurerm_storage_container" "stage" {
	name = "stage"
	storage_account_name  = azurerm_storage_account.curated.name
	container_access_type = "private"
}


# Analytical Sandbox Zone
resource "azurerm_storage_account" "datascience" {
	name                		= "${var.bi_env_prefix}datascience001${var.bi_env_suffix}"
	resource_group_name 		= data.azurerm_resource_group.bi_rg_prm.name
	location             		= data.azurerm_resource_group.bi_rg_prm.location 
	
	account_kind 				= "StorageV2"
	account_tier         		= "Standard"
	account_replication_type 	= "LRS"
	access_tier					= "Hot"
	enable_https_traffic_only  	= "true"
	is_hns_enabled 				= "true"

	tags = merge(map("Comments", "Data Lake persistent Data Science Sandbox Zone using ADLS2."), var.tags)
	
	# Updates not supported by terraform provider
	provisioner "local-exec" {
		command = "./../../modules/bi_data_lake_module/storage/storage_update_logs_settings.sh ${var.subscription_id} ${self.resource_group_name} ${self.name} 60"
	}

}


# BI Logs
resource "azurerm_storage_account" "logs" {
	name                		= "${var.bi_env_prefix}logs001${var.bi_env_suffix}"
	resource_group_name 		= data.azurerm_resource_group.bi_rg_prm.name
	location             		= data.azurerm_resource_group.bi_rg_prm.location 
	
	account_kind 				= "StorageV2"
	account_tier         		= "Standard"
	account_replication_type 	= "LRS"
	access_tier					= "Hot"
	enable_https_traffic_only  	= "true"
	is_hns_enabled 				= "false"

	tags = merge(map("Comments", "Data Lake logs."), var.tags)
	
	# Updates not supported by terraform provider
	provisioner "local-exec" {
		command = "./../../modules/bi_data_lake_module/storage/storage_update_logs_settings.sh ${var.subscription_id} ${self.resource_group_name} ${self.name} 60"
	}

}


# Backup Storage
resource "azurerm_storage_account" "backup" {
	name                		= "${var.bi_env_prefix}backup001${var.bi_env_suffix}"
	resource_group_name 		= data.azurerm_resource_group.bi_rg_prm.name
	location             		= data.azurerm_resource_group.bi_rg_prm.location 
	
	account_kind 				= "StorageV2"
	account_tier         		= "Standard"
	account_replication_type 	= "LRS"
	access_tier					= "Hot"
	enable_https_traffic_only  	= "true"
	is_hns_enabled 				= "false"
	
	blob_properties {
		delete_retention_policy {
			days = "360"
		}
	}

	tags = merge(map("Comments", "Data Lake backups. Move to Cold storage after 360 days."), var.tags)
	
	# Updates not supported by terraform provider
	provisioner "local-exec" {
		command = "./../../modules/bi_data_lake_module/storage/storage_update_logs_settings.sh ${var.subscription_id} ${self.resource_group_name} ${self.name} 60"
	}

	provisioner "local-exec" {
			command = "./../../modules/bi_data_lake_module/storage/storage_update_policy_cold_360_days.sh ${var.subscription_id} ${self.resource_group_name} ${self.name}"
	}
}

resource "azurerm_storage_container" "backups-sql" {
	name = "backups-sql"
	storage_account_name  = azurerm_storage_account.backup.name
	container_access_type = "private"
}

resource "azurerm_storage_container" "backups-ssas" {
	name = "backups-ssas"
	storage_account_name  = azurerm_storage_account.backup.name
	container_access_type = "private"
}

resource "azurerm_storage_container" "backups-other" {
	name = "backups-other"
	storage_account_name  = azurerm_storage_account.backup.name
	container_access_type = "private"
}


# External Vendors Zone
resource "azurerm_storage_account" "vendors" {
	name                		= "${var.bi_env_prefix}extshare001${var.bi_env_suffix}"
	resource_group_name 		= data.azurerm_resource_group.bi_rg_prm.name
	location             		= data.azurerm_resource_group.bi_rg_prm.location 
	
	account_kind 				= "StorageV2"
	account_tier         		= "Standard"
	account_replication_type 	= "LRS"
	access_tier					= "Hot"
	enable_https_traffic_only  	= "true"
	is_hns_enabled 				= "false"
	
	blob_properties {
		delete_retention_policy {
			days = "30"
		}
	}

	tags = merge(map("Comments", "Data Lake External Vendors. 30 soft delete and 60 days retention policy applied."), var.tags)
	
	# Updates not supported by terraform provider
	provisioner "local-exec" {
		command = "./../../modules/bi_data_lake_module/storage/storage_update_logs_settings.sh ${var.subscription_id} ${self.resource_group_name} ${self.name} 60"
	}

	provisioner "local-exec" {
		command = "./../../modules/bi_data_lake_module/storage/storage_update_policy_delete_60_days.sh ${var.subscription_id} ${self.resource_group_name} ${self.name}"
	}
}


# Temporary Storage (Databrics 2 DWH)
resource "azurerm_storage_account" "temp" {
	name                		= "${var.bi_env_prefix}temp001${var.bi_env_suffix}"
	resource_group_name 		= data.azurerm_resource_group.bi_rg_prm.name
	location             		= data.azurerm_resource_group.bi_rg_prm.location 
	
	account_kind 				= "StorageV2"
	account_tier         		= "Standard"
	account_replication_type 	= "LRS"
	access_tier					= "Hot"
	enable_https_traffic_only  	= "true"
	is_hns_enabled 				= "false"
	
	tags = merge(map("Comments", "Data Lake temporary storage. 60 day retention policy applied."), var.tags)

	# Updates not supported by terraform provider
	provisioner "local-exec" {
		command = "./../../modules/bi_data_lake_module/storage/storage_update_logs_settings.sh ${var.subscription_id} ${self.resource_group_name} ${self.name} 60"
	}

	provisioner "local-exec" {
		command = "./../../modules/bi_data_lake_module/storage/storage_update_policy_delete_60_days.sh ${var.subscription_id} ${self.resource_group_name} ${self.name}"
	}
}

# Default containers
resource "azurerm_storage_container" "databricks" {
	name = "databricks"
	storage_account_name  = azurerm_storage_account.temp.name
	container_access_type = "private"
}

resource "azurerm_storage_container" "dwh" {
	name = "databricks"
	storage_account_name  = azurerm_storage_account.temp.name
	container_access_type = "private"
}

# Public Zone - predominantly for sharing | exposing static content needed for e.g. Power BI
resource "azurerm_storage_account" "public" {
	name                		= "${var.bi_env_prefix}publicshare001${var.bi_env_suffix}"
	resource_group_name 		= data.azurerm_resource_group.bi_rg_prm.name
	location             		= data.azurerm_resource_group.bi_rg_prm.location 
	
	account_kind 				= "StorageV2"
	account_tier         		= "Standard"
	account_replication_type 	= "LRS"
	access_tier					= "Hot"
	enable_https_traffic_only  	= "true"
	is_hns_enabled 				= "false"
	
	blob_properties {
		delete_retention_policy {
			days = "30"
		}
	}

	tags = merge(map("Comments", "Data Lake Public Share mostly for PowerBI usage."), var.tags)
}

resource "azurerm_storage_container" "powerbi-res" {
	name = "powerbi-res"
	storage_account_name  = azurerm_storage_account.public.name
	container_access_type = "container"
}
