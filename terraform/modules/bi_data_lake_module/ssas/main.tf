# Make sure we're in EUR BI Sandbox
provider "azurerm" {
	#version 					= "~>"
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

resource "azurerm_analysis_services_server" "ssas001" {
	name							= "${var.bi_env_prefix}ssas001${var.bi_env_suffix}"
	resource_group_name 			= data.azurerm_resource_group.bi_rg_prm.name
	location             			= data.azurerm_resource_group.bi_rg_prm.location 
	sku								= "D1"
	admin_users						= ["witku@statoilfuelretail.com"]
	enable_power_bi_service			= true
	#backup_blob_container_uri = ""
	tags 							= merge(map("Comments", "Primary Analysis Services Server"), var.tags)
}
