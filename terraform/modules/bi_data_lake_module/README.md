# A base template for complete Azure Data Lake environment

Environment consits of:

Azure Storage Accounts covering all Data Lake Zones:
- Landing
- Archive
- Temp|Staging
- Curated
- External Vendors
- Public
- Analytical Sandbox

Azure Synapse (former DWH) and SQL Server configuration database

Azure Analysis Services (Tabular)

Azure Data Factory

Azure Databricks:
- ETL | ELT processing workspace
- Data Science workspace

Azure Key Vaults:
- ETL Key Vault - for all credentials used by ETL components such as ADF, Databricks etc
- Data Science Key Vault - for all credentials exposed in Data Scinence Databricks workspace

Azure VMs:
- Virtual Machine hosting services requiring on-Prem connectivity or else not available as PaaS in Azure:
- MDS Server
- Power BI Gateway
- Azure Integration Runtime (Self Hosted)



