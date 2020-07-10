# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# EXAMPLE GLOBAL SECONDARY INDEX CONFIGURATION
#
# The following dynamodb table description models the table and GSI shown in the AWS SDK example documentation:
# - https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/GSI.html
# - https://www.terraform.io/docs/providers/aws/r/dynamodb_table.html
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

module "terraform-aws-dynamodb" {
  source  = "mineiros-io/dynamodb/aws"
  version = "~> 0.1.0"

  name           = "GameScores"
  billing_mode   = "PROVISIONED"
  read_capacity  = 2
  write_capacity = 2
  hash_key       = "UserId"
  range_key      = "GameTitle"

  attributes = {
    UserId    = "S"
    GameTitle = "S"
    TopScore  = "N"
  }

  ttl_attribute_name = "TimeToExist"

  global_secondary_indexes = [
    {
      name               = "GameTitleIndex"
      hash_key           = "GameTitle"
      range_key          = "TopScore"
      write_capacity     = 1
      read_capacity      = 1
      projection_type    = "INCLUDE"
      non_key_attributes = ["UserId"]
    }
  ]

  table_tags = {
    Name        = "terraform-aws-dynamodb"
    Environment = "example"
  }
}

# ----------------------------------------------------------------------------------------------------------------------
# EXAMPLE PROVIDER CONFIGURATION
# ----------------------------------------------------------------------------------------------------------------------

provider "aws" {
  version = "~> 2.58"
  region  = "us-east-1"
}

# ----------------------------------------------------------------------------------------------------------------------
# ENVIRONMENT VARIABLES:
# ----------------------------------------------------------------------------------------------------------------------
# You can provide your credentials via the
#   AWS_ACCESS_KEY_ID and
#   AWS_SECRET_ACCESS_KEY, environment variables,
# representing your AWS Access Key and AWS Secret Key, respectively.
# Note that setting your AWS credentials using either these (or legacy)
# environment variables will override the use of
#   AWS_SHARED_CREDENTIALS_FILE and
#   AWS_PROFILE.
# The
#   AWS_DEFAULT_REGION and
#   AWS_SESSION_TOKEN environment variables are also used, if applicable.
# ----------------------------------------------------------------------------------------------------------------------
