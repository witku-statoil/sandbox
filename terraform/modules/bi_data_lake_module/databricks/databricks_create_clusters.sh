# Create or update default clusters
# Note: should pin those clusters via GUI to avoid being deleted after 30 days of iniactivity

# databricks clusters create --json-file data-science-interactive-cluster.json
E databricks clusters create --json-file etl-minimal-cluster.json

# Unable to set ACLs via CLI