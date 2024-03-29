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
    aws = "2.58"
  }
}

provider "aws" {
  region = var.aws_region
}

module "test" {
  source = "../.."

  name     = "test-minimal"
  hash_key = "key"
  attributes = {
    key = "S"
  }
}
