variable "project_id" {
  description = "GCP Project name"
  type        = string
}

variable "region" {
  description = "Google Cloud region"
  type        = string
}

variable "location_id" {
  description = "Google Cloud location"
  type        = string
}

variable "zone" {
  description = "Google Cloud zone"
  type        = string
}

variable "deploy_trigger_name" {
  description = "The name for function deploy trigger"
  type        = string
}

variable "runtime_config_name" {
  description = "Gooogle Runtime Configuration name"
  type        = string
}

variable "repository_name" {
  description = "Gooogle Cloud Source repository name"
  type        = string
}

variable "runtime" {
  description = "Runtim for Google Cloud Functions"
  type        = string
}

variable "accept_new_syncs" {
  description = "Initial state of new sync acceptance for the server"
  type        = bool
}

variable "functions" {
  type = list(object({
    name        = string
    entry_point = string
  }))
  default = [
    {
      name        = "info"
      entry_point = "info"
    },
    {
      name        = "bookmarks"
      entry_point = "bookmarks"
    },
  ]
}
