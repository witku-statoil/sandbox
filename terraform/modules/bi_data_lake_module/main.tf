# Add backend
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

# Storage Accounts
module "dl_storage" {
  source                            = "./storage"
  subscription_id					= var.subscription_id
  tenant_id                         = var.tenant_id
  bi_env_prefix                     = var.bi_env_prefix
  bi_env_suffix                     = var.bi_env_suffix
  bi_resource_group_prm             = var.bi_resource_group_prm
  bi_resource_group_scnd            = var.bi_resource_group_scnd
  bi_location_prm                   = var.bi_location_prm
  bi_location_scnd                  = var.bi_location_scnd
  tags                              = var.tags
}

# DWH & SQL Instance (1 each by default)

# Databricks Workspaces (2 by default)
module "dl_databricks" {
  source                            = "./databricks"
  subscription_id					= var.subscription_id
  tenant_id                         = var.tenant_id
  bi_env_prefix                     = var.bi_env_prefix
  bi_env_suffix                     = var.bi_env_suffix
  bi_resource_group_prm             = var.bi_resource_group_prm
  bi_resource_group_scnd            = var.bi_resource_group_scnd
  bi_location_prm                   = var.bi_location_prm
  bi_location_scnd                  = var.bi_location_scnd
  tags                              = var.tags
}

# SSAS Instance (1 by default)
module "dl_ssas" {
  source                            = "./ssas"
  subscription_id					= var.subscription_id
  tenant_id                         = var.tenant_id
  bi_env_prefix                     = var.bi_env_prefix
  bi_env_suffix                     = var.bi_env_suffix
  bi_resource_group_prm             = var.bi_resource_group_prm
  bi_resource_group_scnd            = var.bi_resource_group_scnd
  bi_location_prm                   = var.bi_location_prm
  bi_location_scnd                  = var.bi_location_scnd
  tags                              = var.tags
}

# Azure Data Factory (1 by default)
module "dl_adf" {
  source                            = "./adf"
  subscription_id					= var.subscription_id
  tenant_id                         = var.tenant_id
  bi_env_prefix                     = var.bi_env_prefix
  bi_env_suffix                     = var.bi_env_suffix
  bi_resource_group_prm             = var.bi_resource_group_prm
  bi_resource_group_scnd            = var.bi_resource_group_scnd
  bi_location_prm                   = var.bi_location_prm
  bi_location_scnd                  = var.bi_location_scnd
  tags                              = var.tags
}

# Key Vaults (2, including initial secrets setup)
module "dl_key_vaults" {
  source                            = "./ssas"
  subscription_id					= var.subscription_id
  tenant_id                         = var.tenant_id
  bi_env_prefix                     = var.bi_env_prefix
  bi_env_suffix                     = var.bi_env_suffix
  bi_resource_group_prm             = var.bi_resource_group_prm
  bi_resource_group_scnd            = var.bi_resource_group_scnd
  bi_location_prm                   = var.bi_location_prm
  bi_location_scnd                  = var.bi_location_scnd
  tags                              = var.tags
  
  depends_on = module.dl_storage
}

# VM (1 VM hosting SQL Server, MDS, Power BI Gateway and Azure Data Factory Integration Runtime)



