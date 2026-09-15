terraform {
  required_version = ">= 1.3.0"

  required_providers {
    restapi = {
      source  = "Mastercard/restapi"
      version = "~> 1.20"
    }
  }
}

variable "unusd_api_key" {
  type        = string
  sensitive   = true
  description = "Customer API key from Team settings. Write scope. Do not commit."
}

provider "restapi" {
  uri                  = "https://api.unusd.cloud/v1"
  write_returns_object = true
  headers = {
    Authorization = "Bearer ${var.unusd_api_key}"
    Content-Type  = "application/json"
  }
}

locals {
  accounts = {
    for row in yamldecode(file("${path.module}/accounts.yaml")) :
    row.account_id => row
  }
}

module "accounts" {
  source   = "../.."
  for_each = local.accounts

  account_id = each.key
  alias      = each.value.alias
  schedule   = "0 7 ? * SUN *"
  timezone   = "Europe/Paris"

  email = {
    enabled    = true
    recipients = ["ops@example.com"]
  }
}

output "account_ids" {
  description = "AWS account IDs registered on unusd.cloud."
  value       = [for m in module.accounts : m.account_id]
}
