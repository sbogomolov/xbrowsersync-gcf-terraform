region              = "us-central1" # Currently Cloud Functions can only use "us-central1"
zone                = "us-central1-b"
location_id         = "us-central"
deploy_trigger_name = "deploy-functions"
runtime_config_name = "config"
runtime             = "python38"
accept_new_syncs    = true

# Variables that have to be set:
# - project_id
# - repository_name
