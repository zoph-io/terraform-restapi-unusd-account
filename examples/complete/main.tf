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

variable "slack_webhook" {
  type        = string
  sensitive   = true
  default     = null
  description = "Optional Slack incoming webhook URL."
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
  alias      = "prod"
  enabled    = true
  schedule   = "0 7 ? * SUN *"
  timezone   = "Europe/Paris"

  email = {
    enabled      = true
    recipients   = ["ops@example.com"]
    display_name = "unusd.cloud"
    subject      = "unusd.cloud"
  }

  slack = var.slack_webhook == null ? null : {
    enabled = true
    webhook = var.slack_webhook
  }

  exception_tag     = "unusd"
  custom_tags       = ["Project", "Owner"]
  long_runner_hours = 12
}

output "account_id" {
  description = "Registered AWS account ID."
  value       = module.account.account_id
}
