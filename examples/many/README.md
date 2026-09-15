# Many accounts

Register a whole AWS Organization (100+ accounts) with `for_each` over
`accounts.yaml`. This folder uses `source = "../.."` so you can
`terraform init` from a clone. Callers should pin:

```hcl
source = "github.com/zoph-io/terraform-restapi-unusd-account?ref=v1.0.1"
```

Quote every 12-digit account ID in the YAML. Generate the file from
Organizations if you want:

```bash
aws organizations list-accounts \
  --query 'Accounts[?Status==`ACTIVE`].[Id,Name]' \
  --output text
```

The module does not create the read-only IAM role. Deploy that with StackSets
(or one Terraform workspace per account). Scans start when both exist.

```bash
export TF_VAR_unusd_api_key="unusd_live_..."
terraform init
terraform plan
terraform apply
```
