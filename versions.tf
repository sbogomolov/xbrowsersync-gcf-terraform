terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "sebo-it"

    workspaces {
      name = "xbrowsersync-terraform"
    }
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.65.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
  }
  required_version = ">= 0.12"
}
