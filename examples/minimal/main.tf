terraform {
  required_version = ">= 1.3.0"

  required_providers {
    restapi = {
      source  = "Mastercard/restapi"
      version = ">= 1.20.0"
    }
  }
}

variable "unusd_api_key" {
  type        = string
  sensitive   = true
  description = "Customer API key from Team settings. Write scope. Do not commit."
}

variable "account_id" {
  type        = string
  description = "12-digit AWS account ID."
}

provider "restapi" {
  uri                  = "https://api.unusd.cloud/v1"
  write_returns_object = true
  headers = {
    Authorization = "Bearer ${var.unusd_api_key}"
    Content-Type  = "application/json"
  }
}

module "account" {
  source = "../.."

  account_id = var.account_id
}

output "account_id" {
  description = "Registered AWS account ID."
  value       = module.account.account_id
}
