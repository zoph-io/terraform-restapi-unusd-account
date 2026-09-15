# terraform-restapi-unusd-account

Terraform / OpenTofu module that registers an AWS account on [unusd.cloud](https://unusd.cloud) through the public Customer API (`PUT /v1/accounts/{accountId}`). It sets the same per-account fields as the dashboard: friendly name, schedule, timezone, email, Slack, Teams, SNS, tags.

It does **not** create the read-only IAM role. Deploy that separately (CloudFormation, StackSets, or the spoke role snippet in the app). Scans start only when both the unusd.cloud row and the role exist.

Apache License 2.0. Pin a release tag. Do not copy from `unusd.cloud`.

## Usage

Configure the `Mastercard/restapi` provider in the **root** module. This module does not declare a `provider` block.

```hcl
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
  type      = string
  sensitive = true
}

provider "restapi" {
  uri                  = "https://api.unusd.cloud/v1"
  write_returns_object = true
  headers = {
    Authorization = "Bearer ${var.unusd_api_key}"
    Content-Type  = "application/json"
  }
}

module "prod" {
  source = "github.com/zoph-io/terraform-restapi-unusd-account?ref=v1.0.1"

  account_id = "123456789012"
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

  slack = {
    enabled = true
    webhook = var.slack_webhook
  }

  exception_tag     = "unusd"
  custom_tags       = ["Project", "Owner"]
  long_runner_hours = 12
}
```

Create the API key in Team settings (API keys, at the bottom). Scope `accounts:write`. Startup, Business, Enterprise, and Community. Keys expire.

On `Mastercard/restapi` 3.x you can set `bearer_token = var.unusd_api_key` instead of the Authorization header.

Dev API: set the provider `uri` to `https://api.dev.unusd.cloud/v1` and use a `unusd_test_` key.

`terraform destroy` removes the unusd.cloud account row (same as Remove in the dashboard). It does not delete the IAM role.

## State

The restapi provider stores the PUT body in state, including Slack and Teams webhook URLs. Treat the state backend as secret (encryption, restricted IAM, no commit of `*.tfstate` or `*.tfvars`).

## Requirements

| Name | Version |
| --- | --- |
| terraform | >= 1.3.0 |
| restapi | ~> 1.20 |

## Inputs

| Name | Description | Type | Default | Required |
| --- | --- | --- | --- | --- |
| account_id | 12-digit AWS account ID to register on unusd.cloud. | `string` | n/a | yes |
| alias | Dashboard friendly name. Not the IAM account alias. | `string` | `""` | no |
| enabled | Whether unusd.cloud should scan this account. Omit to keep org default / current value. | `bool` | `null` | no |
| schedule | EventBridge cron (six fields) or `disabled`. Omit for org defaults. | `string` | `null` | no |
| timezone | IANA timezone such as `Europe/Paris`. | `string` | `null` | no |
| email | Email report settings. Omit for org defaults. | `object` | `null` | no |
| slack | Slack incoming webhook. Startup+. | `object` | `null` | no |
| teams | Microsoft Teams or Power Automate webhook. Business+. | `object` | `null` | no |
| sns | Customer SNS topic ARN. Enterprise. No FIFO. | `object` | `null` | no |
| exception_tag | Tag key that skips a resource during scans. | `string` | `null` | no |
| custom_tags | Up to two tag keys copied into reports. | `list(string)` | `null` | no |
| long_runner_hours | Hours before a long-running instance is flagged (1-168). | `number` | `null` | no |

Omitted optional objects keep org Team settings on create, and leave existing values on update (API merge).

Plan gates match the product: Slack Startup+, Teams Business+, SNS Enterprise. At least one notification channel must stay on. Slack host must be `hooks.slack.com`. Teams must be Microsoft or Power Automate. Labels cannot contain `<` or `>`.

## Outputs

| Name | Description |
| --- | --- |
| account_id | AWS account ID registered on unusd.cloud. |

## Examples

- [`examples/minimal`](examples/minimal): account ID only, org defaults for the rest
- [`examples/complete`](examples/complete): schedule, email, Slack, tags
- [`examples/many`](examples/many): `for_each` over a YAML list (100+ accounts)

## Registry

Repository layout follows HashiCorp's [standard module structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure) (`terraform-<PROVIDER>-<NAME>`). After the first `vX.Y.Z` tag, the module can be published on the Terraform Registry as `zoph-io/unusd-account/restapi`.

Until then, pin the GitHub source as shown above. Use `Mastercard/restapi` 1.20.x
(`~> 1.20`). Version 3.x currently breaks `terraform plan` after a successful apply.

## Related

- Product: [unusd.cloud](https://unusd.cloud)
- Many AWS accounts (IAM role + register): [docs.unusd.cloud/how-to/multiple-accounts](https://docs.unusd.cloud/how-to/multiple-accounts/)
- Customer API: [docs.unusd.cloud/how-to/customer-api](https://docs.unusd.cloud/how-to/customer-api/)
- IAM role (Terraform): [docs.unusd.cloud/how-to/use-terraform](https://docs.unusd.cloud/how-to/use-terraform/)
- Security / DPA: [unusd.cloud/security](https://unusd.cloud/security)
