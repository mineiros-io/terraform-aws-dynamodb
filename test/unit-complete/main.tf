# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# UNIT TEST MODULE
# This module exists for the purpose of testing only and should not be
# considered as an example.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

variable "aws_region" {
  description = "(Optional) The AWS region in which all resources will be created."
  type        = string
  default     = "us-east-1"
}

terraform {
  required_providers {
    # replica support was added in 2.58
    # 3.5.0 to 3.6.0 is broken due to https://github.com/terraform-providers/terraform-provider-aws/issues/15115
    aws = ">= 2.58, < 4.0, != 3.5.0, != 3.6.0, != 3.7.0"
  }
}


provider "aws" {
  region = var.aws_region
}

module "test" {
  source = "../.."

  name         = "complete-unit-test"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "UserId"
  range_key    = "GameTitle"

  attributes = {
    UserId    = "S"
    GameTitle = "S"
    TopScore  = "N"
  }

  ttl_attribute_name = "TimeToExist"
  ttl_enabled        = true

  stream_view_type = "KEYS_ONLY"

  kms_type = "AWS_MANAGED"

  # disabled as deployment takes very long
  # replica_region_names = ["eu-west-1"]

  global_secondary_indexes = [
    {
      name               = "GameTitleIndex"
      hash_key           = "GameTitle"
      range_key          = "TopScore"
      write_capacity     = 10
      read_capacity      = 10
      projection_type    = "INCLUDE"
      non_key_attributes = ["UserId"]
    }
  ]

  local_secondary_indexes = [
    {
      name               = "LocalGameTitleIndex"
      range_key          = "TopScore"
      projection_type    = "INCLUDE"
      non_key_attributes = ["UserId"]
    }
  ]

  table_tags = {
    Name        = "complete-unit-test"
    Environment = "production"
  }

  module_tags = {
    Environment = "unknown"
  }
}

output "all" {
  description = "All outputs of the module."
  value       = module.test
}
