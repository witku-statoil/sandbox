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


resource "azurerm_sql_server" "sqlsrvr" {
	name							= "${var.bi_env_prefix}sqlsrv001${var.bi_env_suffix}"
	resource_group_name 			= azurerm_resource_group.bi_rg_prm.name
	location             			= azurerm_resource_group.bi_rg_prm.location 
	version                     	= "12.0"
	administrator_login         	= "bi_admin"
	administrator_login_password	= "3I5PauHvkv774BtVS4K!"
	tags 							= merge(map("Comments", "BI SQL Server - hosting DWH and SQL Config DB"), var.tags)
}

resource "azurerm_sql_database" "dwh" {
	name							= "${var.bi_env_prefix}dwh001${var.bi_env_suffix}"
	resource_group_name 			= azurerm_resource_group.bi_rg_prm.name
	location             			= azurerm_resource_group.bi_rg_prm.location 
	server_name						= azurerm_sql_server.sqlsrvr.name
	edition 						= "DataWarehouse"
	collation 						= "SQL_Latin1_General_CP1_CI_AS"
	requested_service_objective_name= "DW100c"
	tags 							= merge(map("Comments", "Data Warehouse"), var.tags)
}

resource "azurerm_sql_database" "configdb" {
	name							= "${var.bi_env_prefix}configdb001${var.bi_env_suffix}"
	resource_group_name 			= azurerm_resource_group.bi_rg_prm.name
	location             			= azurerm_resource_group.bi_rg_prm.location 
	server_name						= azurerm_sql_server.sqlsrvr.name
	edition 						= "Basic"
	collation 						= "SQL_Latin1_General_CP1_CI_AS"
	requested_service_objective_name= "Basic"
	tags 							= merge(map("Comments", "Config and logging DB"), var.tags)
}