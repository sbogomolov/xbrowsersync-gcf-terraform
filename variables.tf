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

variable "repository_name" {
  description = "Gooogle Cloud Source repository name"
  type        = string
}

variable "accept_new_syncs" {
  type = bool
}

variable "function_names" {
  type = list(string)
  default = [
    "info",
  ]
}
