variable "subscription_id" {
	description = "Subscription ID. Global BI Sandbox"
	default     = "0bdaf605-398a-4b16-9114-85a7489ffed5"
}

variable "tenant_id" {
	description = "Azure Tenant. Alimentation Couche-Tard"
	default     = "19da1f3c-d958-44ea-850d-195c1502525c"
}

variable "bi_env_prefix" {
	description = "The prefix used for all resources. Azure resource names are global so perfix should include circlek reference. Needs to be a short alphanumeric string. Example: `myprefix`. (circlekeubi, crkeubi)"
	default     = "crknabi"
}

variable "bi_env_suffix" {
	description = "The suffix used for all resources. Single letter s - sandbox, d - development, t - test, p - production. Defaults to s"
	default     = "s"
}

variable "bi_resource_group_prm" {
	description = "Primary resource group name where all BI resources will be created - mapped to Default Region."
	default     = "na-bi-sandbox-use2-rg"
}

variable "bi_resource_group_scnd" {
	description = "Secondary resource group name - mapped to paired Azure Region"
	default     = "na-bi-sandbox-usc-rg"
}

variable "bi_location_prm" {
	description = "Primary location"
	default     = "eastus2"
}

variable "bi_location_scnd" {
	description = "Secondardy location. Should perferably use paired Azure Region."
	default     = "centralus"
}

#Global tags which will be assigned to all resources
variable "tags" {
	type = map(string)
	default = {
		Project     = "BI Data Lake"
		Owner       = "Witold Kusnierz"
		Environment = "Sandbox"
		Application = "BI Data Lake" # Add Comments and Appliction at object level
		Creator 	= "witku@circlekeurope.com"
	}
	description = "Any tags which should be assigned to the resources in this example"
}
