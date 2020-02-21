# Databricks Workspaces Scripts

Sets up 2 main Databricks workspaces:
- ETL workspace
- Data Science Analytical Sandbox workspace (this one is probably only really needed in Production)

Additional setup required after initialization:
- both workspaces get default secreats linked to relevant Azure Key Vaults ()
- Worspaces should be linked to Azure AD using SCIM for automated user and group provisioning using Azure AD - note this is currently a manual step currently
- each workspace gets default clusters:
    - ETL Minimial
    - High Concurrency Interactive Cluster
- default mount points and aliases:

```
/mnt/data-lake/landing
/mnt/data-lake/temp
/mnt/data-lake/logs
/mnt/data-lake/archive
/mnt/data-lake/data
/mnt/data-lake/public
/mnt/data-lake/vendors
/mnt/data-lake/backups
/mnt/git/master
```
