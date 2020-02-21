# Databiricks CLI
# https://docs.microsoft.com/en-us/azure/databricks/dev-tools/cli/

# Personal Token must be generated manually
# export DATABRICKS_TOKEN='****'
# export DATABRICKS_HOST='https://eastus2.azuredatabricks.net/?o=1111100294910171#'

# Generate defaut dirs and grant access (or else import from Git)
# Note: there's no way to set ACLs using cli....
# databricks workspace mkdirs  

# Create Groups
# Note: this is not necessary if SCIM provisioninig and SSO enabled
# https://docs.microsoft.com/en-us/azure/databricks/dev-tools/api/latest/scim

# databricks groups create --group-name 'bi_admins_external'
# databricks groups create --group-name 'bi_developers'
# databricks groups create --group-name 'bi_data_scientists'
# databricks groups add-member --parent-name 'bi_developers' --user-name '*@circlekna.com'

# Create Secret Scopes:
# https://eastus2.azuredatabricks.net/?o=1111111111111#secrets/createScope
# databricks secrets create-scope --scope etl-key-vault
# databricks secrets create-scope --scope data-science-key-vault

# databricks secrets put-acl --scope etl-key-vault --principal bi_developers --permission READ
# databricks secrets put-acl --scope data-science-key-vault --principal admins --permission MANAGE
# databricks secrets put-acl --scope data-science-key-vault --principal bi_data_scientists --permission READ
# databricks secrets put-acl --scope etl-key-vault --principal admins --permission MANAGE
