# Changelog

All notable changes to this module are documented here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project uses [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- `examples/many`: `for_each` over a YAML list for org-scale registration.

## [1.0.1] - 2026-09-15

### Fixed

- Set create/read/update/destroy paths to `/accounts/{account_id}` so refresh
  does not GET `/accounts/{id}/{id}`.
- Pin `Mastercard/restapi` to 1.20.x. 3.x fails `terraform plan` after apply.

## [1.0.0] - 2026-09-15

### Added

- Public module to register and configure an AWS account on unusd.cloud via `PUT /v1/accounts/{accountId}`.
- Root-module provider pattern for `Mastercard/restapi`.
- Variable validation for account ID, alias, schedule, Slack host, SNS FIFO, custom tags, and long-runner hours.
- `examples/minimal` and `examples/complete`.
