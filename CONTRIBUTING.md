# Contributing

This module is the IaC wrapper for the unusd.cloud Customer API. New dashboard
account settings must land here in the same change as `PUT /v1/accounts/{accountId}`.

1. `terraform fmt -recursive`
2. `terraform init -backend=false && terraform validate && terraform test`
3. Optional live check against api.dev: apply, `terraform plan` (no changes), update, destroy
4. Do not commit `.tfvars`, state, or API keys
5. Open a PR against `main`. Releases are `vX.Y.Z` tags

Provider configuration stays in the **caller**. Do not add a `provider` block
to the root module.
