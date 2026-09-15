# Security

This module talks to `https://api.unusd.cloud/v1` with a customer API key
configured on the `restapi` provider. Terraform state stores the PUT body,
including Slack and Teams webhook URLs.

- Scope `accounts:write`, store the key in CI secrets, never in git
- Encrypt the state backend
- Rotate and revoke keys in Team settings if they leak

Do not file public GitHub issues for vulnerabilities. Use
[unusd.cloud/security](https://unusd.cloud/security).
