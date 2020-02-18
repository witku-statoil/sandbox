# Make sure we're in EUR BI Sandbox
provider "azurerm" {
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

resource "azurerm_databricks_workspace" "etl" {
	name                	= "${var.bi_env_prefix}etldbcks001${var.bi_env_suffix}"
	resource_group_name 	= azurerm_resource_group.bi_rg_prm.name
	managed_resource_group_name = "${azurerm_resource_group.bi_rg_prm.name}-etl-databricks"
	location             	= azurerm_resource_group.bi_rg_prm.location
	sku						= "premium"
	tags = merge(map("Comments", "ETL Databricks Workspace"), var.tags)
}

resource "azurerm_databricks_workspace" "datascience" {
	name                	= "${var.bi_env_prefix}datascncdbcks001${var.bi_env_suffix}"
	resource_group_name 	= azurerm_resource_group.bi_rg_prm.name
	managed_resource_group_name = "${azurerm_resource_group.bi_rg_prm.name}-datascience-databricks"	
	location             	= azurerm_resource_group.bi_rg_prm.location 
	sku						= "premium"
	tags = merge(map("Comments", "Data Science Sandbox Databricks Workspace"), var.tags)
}