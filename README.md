[<img src="https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg" width="400"/>][homepage]

[![Build Status][badge-build]][build-status]
[![GitHub tag (latest SemVer)][badge-semver]][releases-github]
[![Terraform Version][badge-terraform]][releases-terraform]
[![AWS Provider Version][badge-tf-aws]][releases-aws-provider]
[![Join Slack][badge-slack]][slack]

# terraform-aws-dynamodb

A [Terraform] base module for managing a DynamoDB Table [Amazon Web Services (AWS)][AWS].

***This module supports Terraform v0.14 as well as v0.12.20 and above
and is compatible with the Terraform AWS provider v3 as well as v2.58 and above.***

This module is part of our Infrastructure as Code (IaC) framework
that enables our users and customers to easily deploy and manage reusable,
secure, and production-grade cloud infrastructure.

- [Module Features](#module-features)
- [Getting Started](#getting-started)
- [Module Argument Reference](#module-argument-reference)
  - [Top-level Arguments](#top-level-arguments)
    - [Module Configuration](#module-configuration)
    - [Main Resource Configuration](#main-resource-configuration)
- [Module Attributes Reference](#module-attributes-reference)
- [External Documentation](#external-documentation)
- [Module Versioning](#module-versioning)
  - [Backwards compatibility in `0.0.z` and `0.y.z` version](#backwards-compatibility-in-00z-and-0yz-version)
- [About Mineiros](#about-mineiros)
- [Reporting Issues](#reporting-issues)
- [Contributing](#contributing)
- [Makefile Targets](#makefile-targets)
- [License](#license)

## Module Features

This is the feature set supported by this module:

- **Default Security Settings**:
  Encryption at rest is enabled by default in AWS DynamoDB using the AWS owned Master key.

- **Standard Module Features**:
  DynamoDB Table,
  Global Tables V2 replication configuration,
  DynamoDB Streams,
  TTL,
  Point in Time Recovery,
  Custom Encryption Key via KMS,
  Local Secondary Indexes (LSI),
  Global secondary index (GSI)

- *Features not yet implemented*:
  Auto-scaling

## Getting Started

Most basic usage just setting required arguments:

```hcl
module "terraform-aws-dynamodb" {
  source  = "mineiros-io/dynamodb/aws"
  version = "~> 0.4.0"

  name     = "MyTable"
  hash_key = "HashKey"

  attributes = {
    HashKey = "S"
  }
}
```

## Module Argument Reference

See [variables.tf] and [examples/] for details and use-cases.

### Top-level Arguments

#### Module Configuration

- **`module_enabled`**: *(Optional `bool`)*

  Specifies whether resources in the module will be created.
  Default is `true`.

- **`module_tags`**: *(Optional `map(string)`)*

  A map of tags that will be applied to all created resources that accept tags. Tags defined with 'module_tags' can be
  overwritten by resource-specific tags.
  Default is `{}`.

- **`module_depends_on`**: *(Optional `list(dependencies)`)*

  A list of dependencies. Any object can be _assigned_ to this list to define a hidden external dependency.

#### Main Resource Configuration

- **`name`**: **(Required `string`)**

  The name of the table, this needs to be unique within a region.

- **`hash_key`**: **(Required `string`, Forces new resource)**

  The attribute to use as the hash (partition) key. Must also be defined as an attribute, see below.

- **`billing_mode`**: *(Optional `string`)*

  Controls how you are charged for read and write throughput and how you manage capacity.
  The valid values are `PROVISIONED` and `PAY_PER_REQUEST`.
  Defaults is `"PROVISIONED"`.

- **`range_key`**: *(Optional, Forces new resource)*

  The attribute to use as the range (sort) key. Must also be defined as an attribute, see below.

- **`write_capacity`**: *(Optional `number`)*

  The number of write units for this table. If the billing_mode is PROVISIONED, this field is required.

- **`read_capacity`**: *(Optional `number`)*

  The number of read units for this table. If the billing_mode is PROVISIONED, this field is required.

- **`attributes`**: **(Required `map(string)`)**

  Map of attribute definitions. Only required for `hash_key` and `range_key` attributes.
  The map key is the attribute name.
  The map value is the type of the attribute, which must be a scalar type: S, N, or B for (S)tring, (N)umber or (B)inary data.

  ```
  hask_key = "LockID"

  attributes = {
    LockID = "S"
  }
  ```

  **A note about attributes**

  Only define attributes on the table object that are going to be used as:

  - Table hash key or range key
  - LSI or GSI hash key or range key

  The DynamoDB API expects attribute structure (name and type) to be passed along when creating or updating GSI/LSIs or creating the initial table. In these cases it expects the Hash / Range keys to be provided; because these get re-used in numerous places (i.e the table's range key could be a part of one or more GSIs), they are stored on the table object to prevent duplication and increase consistency. If you add attributes here that are not used in these scenarios it can cause an infinite loop in planning.

- **`ttl_attribute_name`**: *(Optional `string`)*

  The name of the table attribute to store the TTL timestamp in.
  Default is not to store TTL timestamp.

- **`ttl_enabled`**: *(Optional `bool`)*

  Indicates whether ttl is enabled (`true`) or disabled (`false`).
  Default is `true` when `ttl_attribute_name` is set.

- **`point_in_time_recovery_enabled`**: *(Optional `bool`)*

  Whether to enable point-in-time recovery - note that it can take up to 10 minutes to enable for new tables.
  Default is `true`.

- **`replica_region_names`**: *(Optional `set(string)`)*

  A set of region names to configure DynamoDB Global Tables V2 (version 2019.11.21) replication configurations.
  Default is `[]`.

  ```
  replica_region_names = ["eu-west-1", "us-east-1"]
  ```

- **`stream_enabled`**: *(Optional `bool`)*

  Indicates whether Streams are to be enabled (`true`) or disabled (`false`).
  Default is `false`.

- **`stream_view_type`**: *(Optional `string`)*

  When an item in the table is modified, StreamViewType determines what information is written to the table's stream.
  Valid values are `KEYS_ONLY`, `NEW_IMAGE`, `OLD_IMAGE`, `NEW_AND_OLD_IMAGES`.

- **`kms_type`**: *(Optional `string`)*

  Can be one of `AWS_OWNED`, `AWS_MANAGED`, or `CUSTOMER_MANAGED`.

  When creating a new table, you can choose one of the following customer master keys (CMK) to encrypt your table:

  - AWS owned CMK – Default encryption type. The key is owned by DynamoDB (no additional charge).
  - AWS managed CMK – The key is stored in your account and is managed by AWS KMS (AWS KMS charges apply).
  - Customer managed CMK – The key is stored in your account and is created, owned, and managed by you. You have full control over the CMK (AWS KMS charges apply).

  You can switch between the AWS owned CMK, AWS managed CMK, and customer managed CMK at any given time.

  **Attention**: When using the AWS onwed CMK terraform will show `enabled = false` in the `server_side_encryption` block in the plan.

  Default is `AWS_OWNED` when no `kms_key_arn` is sepcified, if `kms_key_arn` is set, the default is `CUSTOMER_MANAGED`.

- **`kms_key_arn`**: *(Optional `string`)*

  The ARN of the CMK that should be used for the AWS KMS encryption (`kms_type = "CUSTOMER_MANAGED"`).

  AWS DynamoDB tables are automatically encrypted at rest with an AWS owned Customer Master Key if this argument isn't specified.
  If you want to use the default DynamoDB CMK, `alias/aws/dynamodb` specify `kms_type = "AWS_OWNED"` and do not set the `kms_key_arn`.
  Default is to use the AWS owned Master key (`kms_type = "AWS_OWNED"`).

- **`local_secondary_indexes`**: *(Optional `list(local_secondary_index)`, Forces new resource)*

  Describe an LSI on the table; these can only be allocated at creation so you cannot change this definition after you have created the resource.
  Default is `[]`.

  ```
  local_secondary_indexes = [
    {
      name               = "someName"
      range_key          = "someKey"
      projection_type    = "ALL"
      non_key_attributes = []
    }
  ]
  ```

  Each element in the list of `local_secondary_indexes` is an object with the following attributes:

  - **`name`**: **(Required `string`)**

    The name of the index.

  - **`range_key`**: **(Required `string`)**

    The name of the range key; must be defined.

  - **`projection_type`**: **(Required `string`)**

    One of `ALL`, `INCLUDE` or `KEYS_ONLY` where `ALL` projects every attribute into the index, `KEYS_ONLY` projects just the hash and range key into the index, and `INCLUDE` projects only the keys specified in the non_key_attributes parameter.

  - **`non_key_attributes`**: *(Optional `list(string)`)*

    Only required with `INCLUDE` as a projection type; a list of attributes to project into the index. These do not need to be defined as attributes on the table.

    This is broken in AWS provider releases 3.5.0 to 3.7.0. Ensure to remove them from the list of available versions if you are using it.
    It was again fixed in version 3.8.0.

    ```
    terraform {
      required_providers {
        # replica support was added in 2.58
        # 3.5.0 to 3.7.0 is broken due to https://github.com/terraform-providers/terraform-provider-aws/issues/15115
        aws = ">= 2.58, < 4.0, != 3.5.0, != 3.6.0, != 3.7.0"
      }
    }
    ```

- **`global_secondary_indexes`**: *(Optional `list(global_secondary_index)`)*

  Describe a GSI for the table; subject to the normal limits on the number of GSIs, projected attributes, etc.
  Default is `[]`.

  Each element in the list of `global_secondary_indexes` is an object with the following attributes:

  - **`name`**: **(Required `string`)**

    The name of the index.

  - **`write_capacity`**: *(Optional `number`)*

    The number of write units for this index. Must be set if billing_mode is set to `PROVISIONED`.

  - **`read_capacity`**: *(Optional `number`)*

    The number of read units for this index. Must be set if billing_mode is set to `PROVISIONED`.

  - **`hash_key`**: **(Required `string`)**

    The name of the hash key in the index; must be defined as an attribute in the resource.

  - **`range_key`**: *(Optional `string`)*

    The name of the range key; must be defined.

  - **`projection_type`**: **(Required `string`)**

    One of `ALL`, `INCLUDE` or `KEYS_ONLY` where `ALL` projects every attribute into the index, `KEYS_ONLY` projects just the hash and range key into the index, and `INCLUDE` projects only the keys specified in the non_key_attributes parameter.

  - **`non_key_attributes`**: *(Optional `list(string)`)*

    Only required with `INCLUDE` as a projection type; a list of attributes to project into the index. These do not need to be defined as attributes on the table.
    Default is `[]`.

    This is broken in AWS provider releases 3.5.0 to 3.7.0. Ensure to remove them from the list of available versions if you are using it.
    It was again fixed in version 3.8.0.

    ```
    terraform {
      required_providers {
        # replica support was added in 2.58
        # 3.5.0 to 3.7.0 is broken due to https://github.com/terraform-providers/terraform-provider-aws/issues/15115
        aws = ">= 2.58, < 4.0, != 3.5.0, != 3.6.0, != 3.7.0"
      }
    }
    ```

- **`table_tags`**: *(Optional `map(string)`)*

  A map of tags to populate on the created table. This will be merged with `module_tags`.
  Default is `{}`.

## Module Attributes Reference

The following attributes are exported by the module:

- **`module_enabled`**

  Whether this module is enabled.

- **`module_inputs`**

  A map of all module arguments. Omitted optional arguments will be represented with their actual defaults.

- **`module_tags`**

  The map of tags that are being applied to all created resources that accept tags.

- **`table`**

  The full `aws_dynamodb_table` object with all its attributes.

- **`computed_arn`**

  Computed table arn in the format: `arn:aws:dynamodb:<region>:<account_id>:table/<name>`.
  This value can be used to create predictable policies in cases where terraform depends on the ARN of the table that will be created in the plan phase but can only access the ARN of the table after applying it.


## External Documentation

- AWS Documentation IAM:
  - https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Introduction.html
  - https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/globaltables.V2.html

- Terraform AWS Provider Documentation:
  - https://www.terraform.io/docs/providers/aws/r/dynamodb_table.html

## Module Versioning

This Module follows the principles of [Semantic Versioning (SemVer)].

Given a version number `MAJOR.MINOR.PATCH`, we increment the:

1. `MAJOR` version when we make incompatible changes,
2. `MINOR` version when we add functionality in a backwards compatible manner, and
3. `PATCH` version when we make backwards compatible bug fixes.

### Backwards compatibility in `0.0.z` and `0.y.z` version

- Backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is increased. (Initial development)
- Backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is increased. (Pre-release)

## About Mineiros

[Mineiros][homepage] is a remote-first company headquartered in Berlin, Germany
that solves development, automation and security challenges in cloud infrastructure.

Our vision is to massively reduce time and overhead for teams to manage and
deploy production-grade and secure cloud infrastructure.

We offer commercial support for all of our modules and encourage you to reach out
if you have any questions or need help. Feel free to email us at [hello@mineiros.io] or join our
[Community Slack channel][slack].

## Reporting Issues

We use GitHub [Issues] to track community reported issues and missing features.

## Contributing

Contributions are always encouraged and welcome! For the process of accepting changes, we use
[Pull Requests]. If you'd like more information, please see our [Contribution Guidelines].

## Makefile Targets

This repository comes with a handy [Makefile].
Run `make help` to see details on each available target.

## License

[![license][badge-license]][apache20]

This module is licensed under the Apache License Version 2.0, January 2004.
Please see [LICENSE] for full details.

Copyright &copy; 2021 [Mineiros GmbH][homepage]

<!-- References -->

[homepage]: https://mineiros.io/?ref=terraform-aws-dynamodb
[hello@mineiros.io]: mailto:hello@mineiros.io

[badge-build]: https://github.com/mineiros-io/terraform-aws-dynamodb/workflows/CI/CD%20Pipeline/badge.svg
[badge-semver]: https://img.shields.io/github/v/tag/mineiros-io/terraform-aws-dynamodb.svg?label=latest&sort=semver
[badge-license]: https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg
[badge-terraform]: https://img.shields.io/badge/terraform-0.13%20and%200.12.20+-623CE4.svg?logo=terraform
[badge-slack]: https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack

[build-status]: https://github.com/mineiros-io/terraform-aws-dynamodb/actions
[releases-github]: https://github.com/mineiros-io/terraform-aws-dynamodb/releases

[badge-tf-aws]: https://img.shields.io/badge/AWS-3%20and%202.58+-F8991D.svg?logo=terraform
[releases-aws-provider]: https://github.com/terraform-providers/terraform-provider-aws/releases

[releases-terraform]: https://github.com/hashicorp/terraform/releases
[apache20]: https://opensource.org/licenses/Apache-2.0
[slack]: https://join.slack.com/t/mineiros-community/shared_invite/zt-ehidestg-aLGoIENLVs6tvwJ11w9WGg
[Terraform]: https://www.terraform.io
[AWS]: https://aws.amazon.com/
[Semantic Versioning (SemVer)]: https://semver.org/

[variables.tf]: https://github.com/mineiros-io/terraform-aws-dynamodb/blob/master/variables.tf
[examples/]: https://github.com/mineiros-io/terraform-aws-dynamodb/blob/master/examples
[Issues]: https://github.com/mineiros-io/terraform-aws-dynamodb/issues
[LICENSE]: https://github.com/mineiros-io/terraform-aws-dynamodb/blob/master/LICENSE
[Makefile]: https://github.com/mineiros-io/terraform-aws-dynamodb/blob/master/Makefile
[Pull Requests]: https://github.com/mineiros-io/terraform-aws-dynamodb/pulls
[Contribution Guidelines]: https://github.com/mineiros-io/terraform-aws-dynamodb/blob/master/CONTRIBUTING.md
