# Changelog

All notable changes to this module are documented here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project uses [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-09-15

### Added

- Public module to register and configure an AWS account on unusd.cloud via `PUT /v1/accounts/{accountId}`.
- Root-module provider pattern for `Mastercard/restapi`.
- Variable validation for account ID, alias, schedule, Slack host, SNS FIFO, custom tags, and long-runner hours.
- `examples/minimal` and `examples/complete`.
