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

variable "name" {
  type        = string
  description = "(Optional) The name of the table, this needs to be unique within a region."
  default     = "test"
}

variable "hash_key" {
  type        = string
  description = "(Optional, Forces new resource) The attribute to use as the hash (partition) key. Must also be defined as an attribute."
  default     = "key"
}

variable "attributes" {
  type        = map(string)
  description = "(Optional) List of nested attribute definitions."
  default = {
    "key" = "S"
  }
}

provider "aws" {
  region  = var.aws_region
  version = "~> 2.58"
}

module "test" {
  source = "../.."

  module_enabled = false

  name       = var.name
  hash_key   = var.hash_key
  attributes = var.attributes
}

output "all" {
  description = "All outputs of the module."
  value       = module.test
}
