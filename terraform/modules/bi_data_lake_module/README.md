# A base template for complete Azure Data Lake environment

Environment consits of:

**Azure Storage Accounts** covering all Data Lake Zones:
- Landing
- Archive
- Temp|Staging
- Curated
- External Vendors
- Public
- Analytical Sandbox

**Azure Synapse** (former DWH) instance and SQL Server configuration database

**Azure Analysis Services** for hosting Tabular models exposed to end users

**Azure Data Factory** for high-level ETL orchestration

**Azure Databricks** workspaces:
- ETL | ELT processing workspace
- Data Science workspace

**Azure Key Vaults**:
- ETL Key Vault - for all credentials used by ETL components such as ADF, Databricks etc
- Data Science Key Vault - for all credentials exposed in Data Scinence Databricks workspace

**Azure VMs**:
- at least one Virtual Machine for hosting services requiring On-Prem connectivity or else not available as PaaS in Azure:
    - MDS Server
    - Power BI Gateway
    - Azure ADF Integration Runtime (Self Hosted)

*Components not yet covered by terraform configuration: Logic Apps, Automation Accounts*

Module structure:
```
bi_data_lake_module/
├── adf
│   ├── README.md
│   ├── main.tf
│   └── variables.tf
├── databricks
│   ├── README.md
│   ├── main.tf
│   └── variables.tf
├── key_vault
│   ├── README.md
│   ├── main.tf
│   └── variables.tf
├── sql
│   ├── README.md
│   ├── main.tf
│   └── variables.tf
├── ssas
│   ├── README.md
│   ├── main.tf
│   └── variables.tf
├── storage
│   ├── README.md
│   ├── main.tf
│   ├── outputs.tf
│   ├── storage_update_logs_settings.sh
│   ├── storage_update_policy_cold_360_days.sh
│   ├── storage_update_policy_delete_60_days.sh
│   └── variables.tf
├── vm
│   ├── README.md
│   ├── main.tf
│   └── variables.tf
├── README.md
├── main.tf
├── outputs.tf
└── variables.tf

```