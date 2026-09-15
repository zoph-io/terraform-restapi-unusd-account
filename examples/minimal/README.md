# Minimal

Registers the AWS account and leaves schedule, notifications, and tags on
org Team settings defaults.

```hcl
module "account" {
  source = "github.com/zoph-io/terraform-restapi-unusd-account?ref=v1.0.0"

  account_id = var.account_id
}
```

This folder uses `source = "../.."` so you can `terraform init` from a clone.
Callers should pin the GitHub (or Registry) address above.

```bash
terraform init
terraform plan
terraform apply
```
