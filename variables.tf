variable "project_id" {
  description = "GCP Project name"
  type        = string
}

variable "region" {
  description = "Google Cloud region"
  type        = string
}

variable "zone" {
  description = "Google Cloud zone"
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
