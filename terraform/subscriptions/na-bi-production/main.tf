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

# Data Lake blue print
module "data_lake" {
  source                            = "./../../modules/bi_data_lake_module"
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


