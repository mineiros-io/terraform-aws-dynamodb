# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.4.1]
### Added
- feat: Add `computed_arn` output.

## [0.4.0]
### Changed
- BREAKING: Enable point-in-time recovery by default. Set `point_in_time_recovery_enabled = false` if desired.

## [0.3.0]
### Changed
- Add support for Terraform v0.13
- Prepare support for Terraform v0.14 by removing version argument from provider config

## [0.2.0] - 2020-08-03
### Changed
- Add support for terraform aws provider 3.x
- Update tests to test against 3.0 aws provider

## [0.1.2] - 2020-07-10
### Added
- Add `kms_type` argument to support specifying which key to use to encrypt data at rest.

## [0.1.1] - 2020-07-10
### Added
- Add a test for minimal provider version to catch needed upgrades early

### Changed
- Update build-system

### Fixed
- Fix version constraint and require aws provider >= 2.58 for replica support

## [0.1.0] - 2020-07-06
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
- Add examples

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
[Unreleased]: https://github.com/mineiros-io/terraform-module-template/compare/v0.4.1...HEAD
[0.4.1]: https://github.com/mineiros-io/terraform-module-template/compare/v0.4.0...v0.4.1
<!-- markdown-link-check-disabled -->
[0.4.0]: https://github.com/mineiros-io/terraform-module-template/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/mineiros-io/terraform-module-template/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/mineiros-io/terraform-module-template/compare/v0.1.2...v0.2.0
[0.1.2]: https://github.com/mineiros-io/terraform-module-template/compare/v0.1.1...v0.1.2
[0.1.1]: https://github.com/mineiros-io/terraform-module-template/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/mineiros-io/terraform-module-template/compare/v0.0.1...v0.1.0
[0.0.1]: https://github.com/mineiros-io/terraform-module-template/releases/tag/v0.0.1
