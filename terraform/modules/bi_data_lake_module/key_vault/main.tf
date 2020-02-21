# Make sure we're in EUR BI Sandbox
provider "azurerm" {
	#version 					= "~>"
	version 					= "=1.44.0" 
	subscription_id 			= var.subscription_id
	tenant_id       			= var.tenant_id
}

# Load from variables.tf
resource "azurerm_resource_group" "bi_rg_prm" {
	name     = var.bi_resource_group_prm
	location = var.bi_location_prm
	tags = var.tags
}

# ETL Key Valult
resource "azurerm_key_vault" "etl_key_vault" {
	name					= "${var.bi_env_prefix}etlkv001${var.bi_env_suffix}"
	location				= azurerm_resource_group.bi_rg_prm.location 
	resource_group_name		= azurerm_resource_group.bi_rg_prm.name
	tenant_id       		= var.tenant_id
	sku_name 				= "premium"

	tags = merge(map("Comments", "ELT Key Vault used by ADF, ETL Databricks etc."), var.tags)
}

# Data Science Key Valult
resource "azurerm_key_vault" "datascience_key_vault" {
	name					= "${var.bi_env_prefix}datasckv001${var.bi_env_suffix}"
	location				= azurerm_resource_group.bi_rg_prm.location 
	resource_group_name		= azurerm_resource_group.bi_rg_prm.name
	tenant_id       		= var.tenant_id	
	sku_name 				= "premium"

	tags = merge(map("Comments", "Data Science Sandbox Key Vault used by Databricks."), var.tags)
}

# Default secrets for ETL Key Vault

# Default secrets for Data Science Key Vault