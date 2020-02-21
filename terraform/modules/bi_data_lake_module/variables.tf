variable "subscription_id" {
	description = "Subscription ID. Defaults to EUR BI Sandbox"
	default     = "d47fd6db-571f-4cdc-8fe2-987b0152369c"
}

variable "tenant_id" {
	description = "Azure Tenant. Defaults to CircleK Europe"
	default     = "deb87405-c3fd-48f8-af81-65ca6d8d8e57"
}

variable "bi_env_code" {
	description = "Environment code - PROD for Production, TEST, DEV for development, SBOX for Sandbox.
	Value used for looking up environment specific object such as Azure AD Groups etc."
	default     = "SBOX"
}

variable "bi_env_prefix" {
	description = "The prefix used for all resources. Azure resource names are global so perfix should include circlek reference. Needs to be a short alphanumeric string. Example: `myprefix`. (circlekeubi, crkeubi)"
	default     = "circlekeubi"
}

variable "bi_env_suffix" {
	description = "The suffix used for all resources. Single letter s - sandbox, d - development, t - test, p - production. Defaults to s"
	default     = "s"
}

variable "bi_resource_group_prm" {
	description = "Primary resource group name where all BI resources will be created - mapped to Default Region."
	default     = "eur-bi-sandbox-witku"
}

variable "bi_resource_group_scnd" {
	description = "Primary resource group name where all BI resources will be created"
	default     = "eur-bi-sandbox-witku-secondary-region"
}

variable "bi_location_prm" {
	description = "Primary location"
	default     = "westeurope"
}

variable "bi_location_scnd" {
	description = "Secondardy location. Should perferably use paired Azure Region."
	default     = "northeurope"
}

#Global tags which will be assigned to all resources
variable "tags" {
	type = map(string)
	default = {
		Project     = "BI Data Lake"
		Owner       = "Witold Kusnierz"
		Environment = "Sandbox"
		Application = "BI Data Lake" # Add Comments and Appliction at object level
	}
	description = "Any tags which should be assigned to the resources in this example"
}
