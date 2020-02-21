# Azure Key Vaults for all credentials and secrets used by ETL processes, ADF and Databricks

Sets up 2 key vaults:
- ETL
- Data Science (limited scope only granting access to Curated (rad-only) and Sandbox Zones)

By default only key secrets are setup. Data-source specific keys should be setup as part of code deployment. 

*Note: Secrets are initialized empty - please update afterwards.*

Secrets - Storage:
- storage-landing-account
- storage-landing-account-key
- storage-archive-account
- storage-archive-account-key
- storage-data-account (ADLS2 Curated Zone)
- storage-data-account-key
- storage-temp-account
- storage-temp-account-key
- storage-logs-account
- storage-logs-account-key
- storage-extshare-account
- storage-extshare-account-key
- storage-analytical-sandbox-account (ADLS2 Analytical Sandbox)
- storage-analytical-sandbox-account-key

Secrets - DB:
- dwh-connection-str
- dwh-databricks-user
- dwh-databricks-password
- dwh-etl-smallrc-user
- dwh-etl-smallrc-password
- config-db-connection-str
- config-db-etl-user
- config-db-etl-password
