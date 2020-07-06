# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- Add `module_enabled` test
- Add `module_tags` support
- Add `range_key` support
- Add TTL support
- Add stream support
- Add replica configuration for DynamoDB Global Tables V2 support
- Add point-in-time-recovery support
- Add local secondary index (LSI) support
- Add global secondary index (GSI) support
- Add `module_inputs` output
- Add `CHANGELOG.md`
- Add unit tests for minimal, complete, and disabled feature sets

### Changed
- Update build-system
- Improve documentation
- Improve variable descriptions
- Improve attributes documentation

### Fixed
- Fix table output value to output the table not a list with one element

## [0.0.1] - 2020-05-23
### Added
- Implement initial support for `aws_dynamodb_table` resource
- Add support for Billing Mode
- Add support for Server Side Encryption (SSE)

<!-- markdown-link-check-disable -->
[Unreleased]: https://github.com/mineiros-io/terraform-module-template/compare/v1.0.0...HEAD
[0.0.1]: https://github.com/mineiros-io/terraform-module-template/releases/tag/v0.0.1
<!-- markdown-link-check-disabled -->
