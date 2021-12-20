header {
  image = "https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg"
  url   = "https://mineiros.io/?ref=terraform-aws-dynamodb"

  badge "build" {
    image = "https://github.com/mineiros-io/terraform-aws-dynamodb/workflows/CI/CD%20Pipeline/badge.svg"
    url   = "https://github.com/mineiros-io/terraform-aws-dynamodb/actions"
    text  = "Build Status"
  }

  badge "semver" {
    image = "https://img.shields.io/github/v/tag/mineiros-io/terraform-aws-dynamodb.svg?label=latest&sort=semver"
    url   = "https://github.com/mineiros-io/terraform-aws-dynamodb/releases"
    text  = "GitHub tag (latest SemVer)"
  }

  badge "terraform" {
    image = "https://img.shields.io/badge/terraform-1.x%20|%200.15%20|%200.14%20|%200.13%20|%200.12.20+-623CE4.svg?logo=terraform"
    url   = "https://github.com/hashicorp/terraform/releases"
    text  = "Terraform Version"
  }

  badge "tf-aws-provider" {
    image = "https://img.shields.io/badge/AWS-3%20and%202.58+-F8991D.svg?logo=terraform"
    url   = "https://github.com/terraform-providers/terraform-provider-aws/releases"
    text  = "AWS Provider Version"
  }

  badge "slack" {
    image = "https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack"
    url   = "https://join.slack.com/t/mineiros-community/shared_invite/zt-ehidestg-aLGoIENLVs6tvwJ11w9WGg"
    text  = "Join Slack"
  }
}

section {
  title   = "terraform-aws-dynamodb"
  toc     = true
  content = <<-END
    A [Terraform] base module for managing a DynamoDB Table [Amazon Web Services (AWS)][AWS].

    ***This module supports Terraform v1.x, v0.15, v0.14, v0.13 as well as v0.12.20 and above
    and is compatible with the Terraform AWS provider v3 as well as v2.58 and above.***

    This module is part of our Infrastructure as Code (IaC) framework
    that enables our users and customers to easily deploy and manage reusable,
    secure, and production-grade cloud infrastructure.
  END

  section {
    title   = "Module Features"
    content = <<-END
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
    END
  }

  section {
    title   = "Getting Started"
    content = <<-END
      Most basic usage just setting required arguments:

      ```hcl
      module "terraform-aws-dynamodb" {
        source  = "mineiros-io/dynamodb/aws"
        version = "~> 0.6.0"

        name     = "MyTable"
        hash_key = "HashKey"

        attributes = {
          HashKey = "S"
        }
      }
      ```
    END
  }

  section {
    title   = "Module Argument Reference"
    content = <<-END
      See [variables.tf] and [examples/] for details and use-cases.
    END

    section {
      title = "Top-level Arguments"

      section {
        title = "Module Configuration"

        variable "module_enabled" {
          type        = bool
          default     = true
          description = <<-END
            Specifies whether resources in the module will be created.
          END
        }

        variable "module_tags" {
          type        = map(string)
          default     = {}
          description = <<-END
            A map of tags that will be applied to all created resources that accept tags. Tags defined with 'module_tags' can be overwritten by resource-specific tags.
          END
        }

        variable "module_depends_on" {
          type        = any
          readme_type = "list(dependencies)"
          description = <<-END
            A list of dependencies. Any object can be _assigned_ to this list to define a hidden external dependency.
          END
        }
      }

      section {
        title = "Main Resource Configuration"

        variable "name" {
          required    = true
          type        = string
          description = <<-END
            The name of the table, this needs to be unique within a region.
          END
        }

        variable "hash_key" {
          required    = true
          type        = string
          description = <<-END
            The attribute to use as the hash (partition) key. Must also be defined as an attribute, see below. Forces new resource.
          END
        }

        variable "billing_mode" {
          type        = string
          default     = "PROVISIONED"
          description = <<-END
            Controls how you are charged for read and write throughput and how you manage capacity.
            The valid values are `PROVISIONED` and `PAY_PER_REQUEST`.
          END
        }

        variable "range_key" {
          type        = string
          description = <<-END
            The attribute to use as the range (sort) key. Must also be defined as an attribute, see below. Forces new resource.
          END
        }

        variable "write_capacity" {
          type        = number
          default     = 5
          description = <<-END
            The number of write units for this table. If the billing_mode is PROVISIONED, this field is required.
          END
        }

        variable "read_capacity" {
          type        = number
          default     = 5
          description = <<-END
            The number of read units for this table. If the billing_mode is PROVISIONED, this field is required.
          END
        }

        variable "attributes" {
          required    = true
          type        = map(string)
          description = <<-END
            List of nested attribute definitions. Only required for hash_key and range_key attributes.

            ```
            hash_key = "LockID"

            attributes = {
              LockID = "S"
            }
            ```

            **A note about attributes**

            Only define attributes on the table object that are going to be used as:

            - Table hash key or range key
            - LSI or GSI hash key or range key

            The DynamoDB API expects attribute structure (name and type) to be passed along when creating or updating GSI/LSIs or creating the initial table. In these cases it expects the Hash / Range keys to be provided; because these get re-used in numerous places (i.e the table's range key could be a part of one or more GSIs), they are stored on the table object to prevent duplication and increase consistency. If you add attributes here that are not used in these scenarios it can cause an infinite loop in planning.
          END

          attribute "name" {
            required    = true
            type        = string
            description = <<-END
              The name of the attribute
            END
          }

          attribute "type" {
            required    = true
            type        = string
            description = <<-END
              Attribute type, which must be a scalar type: S, N, or B for (S)tring, (N)umber or (B)inary data
            END
          }
        }

        variable "ttl_attribute_name" {
          type        = string
          description = <<-END
            The name of the table attribute to store the TTL timestamp in.
            Default is not to store TTL timestamp.
          END
        }

        variable "ttl_enabled" {
          type        = bool
          default     = true
          description = <<-END
            Indicates whether ttl is enabled (`true`) or disabled (`false`). Default applies when `ttl_attribute_name` is set.
          END
        }

        variable "point_in_time_recovery_enabled" {
          type        = bool
          default     = true
          description = <<-END
            Whether to enable point-in-time recovery - note that it can take up to 10 minutes to enable for new tables.
          END
        }

        variable "replica_region_names" {
          type           = set(string)
          default        = []
          description    = <<-END
            A set of region names to configure DynamoDB Global Tables V2 (version 2019.11.21) replication configurations.
          END
          readme_example = <<-END
            replica_region_names = ["eu-west-1", "us-east-1"]
          END
        }

        variable "stream_enabled" {
          type        = bool
          description = <<-END
            Indicates whether Streams are to be enabled (`true`) or disabled (`false`).
          END
        }

        variable "stream_view_type" {
          type        = string
          description = <<-END
            When an item in the table is modified, StreamViewType determines what information is written to the table's stream.
            Valid values are `KEYS_ONLY`, `NEW_IMAGE`, `OLD_IMAGE`, `NEW_AND_OLD_IMAGES`.
          END
        }

        variable "kms_type" {
          type        = string
          description = <<-END
            Can be one of `AWS_OWNED`, `AWS_MANAGED`, or `CUSTOMER_MANAGED`.

            When creating a new table, you can choose one of the following customer master keys (CMK) to encrypt your table:

            - AWS owned CMK - Default encryption type. The key is owned by DynamoDB (no additional charge).
            - AWS managed CMK - The key is stored in your account and is managed by AWS KMS (AWS KMS charges apply).
            - Customer managed CMK - The key is stored in your account and is created, owned, and managed by you. You have full control over the CMK (AWS KMS charges apply).

            You can switch between the AWS owned CMK, AWS managed CMK, and customer managed CMK at any given time.

            **Attention**: When using the AWS onwed CMK terraform will show `enabled = false` in the `server_side_encryption` block in the plan.

            Default is `AWS_OWNED` when no `kms_key_arn` is specified, if `kms_key_arn` is set, the default is `CUSTOMER_MANAGED`.
          END
        }

        variable "kms_key_arn" {
          type        = string
          description = <<-END
            The ARN of the CMK that should be used for the AWS KMS encryption (`kms_type = "CUSTOMER_MANAGED"`).

            AWS DynamoDB tables are automatically encrypted at rest with an AWS owned Customer Master Key if this argument isn't specified.
            If you want to use the default DynamoDB CMK, `alias/aws/dynamodb` specify `kms_type = "AWS_OWNED"` and do not set the `kms_key_arn`.
            Default is to use the AWS owned Master key (`kms_type = "AWS_OWNED"`).
          END
        }

        variable "local_secondary_indexes" {
          type           = any
          readme_type    = "list(local_secondary_index)"
          default        = []
          description    = <<-END
            Describe an LSI on the table; these can only be allocated at creation so you cannot change this definition after you have created the resource. Forces new resource.
          END
          readme_example = <<-END
            local_secondary_indexes = [
              {
                name               = "someName"
                range_key          = "someKey"
                projection_type    = "ALL"
                non_key_attributes = []
              }
            ]
          END

          attribute "name" {
            required    = true
            type        = string
            description = <<-END
              The name of the index.
            END
          }

          attribute "range_key" {
            required    = true
            type        = string
            description = <<-END
              The name of the range key; must be defined.
            END
          }

          attribute "projection_type" {
            required    = true
            type        = string
            description = <<-END
              One of `ALL`, `INCLUDE` or `KEYS_ONLY` where `ALL` projects every attribute into the index, `KEYS_ONLY` projects just the hash and range key into the index, and `INCLUDE` projects only the keys specified in the non_key_attributes parameter.
            END
          }

          attribute "non_key_attributes" {
            type        = list(string)
            description = <<-END
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
            END
          }
        }

        variable "global_secondary_indexes" {
          type        = any
          readme_type = "list(global_secondary_index)"
          default     = []
          description = <<-END
            Describe a GSI for the table; subject to the normal limits on the number of GSIs, projected attributes, etc.
          END

          attribute "name" {
            required    = true
            type        = string
            description = <<-END
              The name of the index.
            END
          }

          attribute "write_capacity" {
            type        = number
            description = <<-END
              The number of write units for this index. Must be set if billing_mode is set to `PROVISIONED`.
            END
          }

          attribute "read_capacity" {
            type        = number
            description = <<-END
              The number of read units for this index. Must be set if billing_mode is set to `PROVISIONED`.
            END
          }

          attribute "hash_key" {
            required    = true
            type        = string
            description = <<-END
              The name of the hash key in the index; must be defined as an attribute in the resource.
            END
          }

          attribute "range_key" {
            type        = string
            description = <<-END
              The name of the range key; must be defined.
            END
          }

          attribute "projection_type" {
            required    = true
            type        = string
            description = <<-END
              One of `ALL`, `INCLUDE` or `KEYS_ONLY` where `ALL` projects every attribute into the index, `KEYS_ONLY` projects just the hash and range key into the index, and `INCLUDE` projects only the keys specified in the non_key_attributes parameter.
            END
          }

          attribute "non_key_attributes" {
            type        = list(string)
            default     = []
            description = <<-END
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
            END
          }
        }

        variable "table_tags" {
          type        = map(string)
          default     = {}
          description = <<-END
            A map of tags to populate on the created table. This will be merged with `module_tags`.
          END
        }
      }
    }
  }

  section {
    title   = "Module Outputs"
    content = <<-END
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
    END
  }

  section {
    title = "External Documentation"

    section {
      title   = "AWS Documentation"
      content = <<-END
        - https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Introduction.html
        - https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/globaltables.V2.html
      END
    }

    section {
      title   = "Terraform AWS Provider Documentation"
      content = <<-END
        - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table
      END
    }
  }

  section {
    title   = "Module Versioning"
    content = <<-END
      This Module follows the principles of [Semantic Versioning (SemVer)].

      Given a version number `MAJOR.MINOR.PATCH`, we increment the:

      1. `MAJOR` version when we make incompatible changes,
      2. `MINOR` version when we add functionality in a backwards compatible manner, and
      3. `PATCH` version when we make backwards compatible bug fixes.
    END

    section {
      title   = "Backwards compatibility in `0.0.z` and `0.y.z` version"
      content = <<-END
        - Backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is increased. (Initial development)
        - Backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is increased. (Pre-release)
      END
    }
  }

  section {
    title   = "About Mineiros"
    content = <<-END
      [Mineiros][homepage] is a remote-first company headquartered in Berlin, Germany
      that solves development, automation and security challenges in cloud infrastructure.

      Our vision is to massively reduce time and overhead for teams to manage and
      deploy production-grade and secure cloud infrastructure.

      We offer commercial support for all of our modules and encourage you to reach out
      if you have any questions or need help. Feel free to email us at [hello@mineiros.io] or join our
      [Community Slack channel][slack].
    END
  }

  section {
    title   = "Reporting Issues"
    content = <<-END
      We use GitHub [Issues] to track community reported issues and missing features.
    END
  }

  section {
    title   = "Contributing"
    content = <<-END
      Contributions are always encouraged and welcome! For the process of accepting changes, we use
      [Pull Requests]. If you'd like more information, please see our [Contribution Guidelines].
    END
  }

  section {
    title   = "Makefile Targets"
    content = <<-END
      This repository comes with a handy [Makefile].
      Run `make help` to see details on each available target.
    END
  }

  section {
    title   = "License"
    content = <<-END
      [![license][badge-license]][apache20]

      This module is licensed under the Apache License Version 2.0, January 2004.
      Please see [LICENSE] for full details.

      Copyright &copy; 2020-2022 [Mineiros GmbH][homepage]
    END
  }
}

references {
  ref "homepage" {
    value = "https://mineiros.io/?ref=terraform-aws-dynamodb"
  }
  ref "hello@mineiros.io" {
    value = "mailto:hello@mineiros.io"
  }
  ref "badge-build" {
    value = "https://github.com/mineiros-io/terraform-aws-dynamodb/workflows/CI/CD%20Pipeline/badge.svg"
  }
  ref "badge-semver" {
    value = "https://img.shields.io/github/v/tag/mineiros-io/terraform-aws-dynamodb.svg?label=latest&sort=semver"
  }
  ref "badge-license" {
    value = "https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg"
  }
  ref "badge-terraform" {
    value = "https://img.shields.io/badge/terraform-1.x%20|%200.15%20|%200.14%20|%200.13%20|%200.12.20+-623CE4.svg?logo=terraform"
  }
  ref "badge-slack" {
    value = "https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack"
  }
  ref "build-status" {
    value = "https://github.com/mineiros-io/terraform-aws-dynamodb/actions"
  }
  ref "releases-github" {
    value = "https://github.com/mineiros-io/terraform-aws-dynamodb/releases"
  }
  ref "badge-tf-aws" {
    value = "https://img.shields.io/badge/AWS-3%20and%202.58+-F8991D.svg?logo=terraform"
  }
  ref "releases-aws-provider" {
    value = "https://github.com/terraform-providers/terraform-provider-aws/releases"
  }
  ref "releases-terraform" {
    value = "https://github.com/hashicorp/terraform/releases"
  }
  ref "apache20" {
    value = "https://opensource.org/licenses/Apache-2.0"
  }
  ref "slack" {
    value = "https://join.slack.com/t/mineiros-community/shared_invite/zt-ehidestg-aLGoIENLVs6tvwJ11w9WGg"
  }
  ref "Terraform" {
    value = "https://www.terraform.io"
  }
  ref "AWS" {
    value = "https://aws.amazon.com/"
  }
  ref "Semantic Versioning (SemVer)" {
    value = "https://semver.org/"
  }
  ref "variables.tf" {
    value = "https://github.com/mineiros-io/terraform-aws-dynamodb/blob/master/variables.tf"
  }
  ref "examples/" {
    value = "https://github.com/mineiros-io/terraform-aws-dynamodb/blob/master/examples"
  }
  ref "Issues" {
    value = "https://github.com/mineiros-io/terraform-aws-dynamodb/issues"
  }
  ref "LICENSE" {
    value = "https://github.com/mineiros-io/terraform-aws-dynamodb/blob/master/LICENSE"
  }
  ref "Makefile" {
    value = "https://github.com/mineiros-io/terraform-aws-dynamodb/blob/master/Makefile"
  }
  ref "Pull Requests" {
    value = "https://github.com/mineiros-io/terraform-aws-dynamodb/pulls"
  }
  ref "Contribution Guidelines" {
    value = "https://github.com/mineiros-io/terraform-aws-dynamodb/blob/master/CONTRIBUTING.md"
  }
}
