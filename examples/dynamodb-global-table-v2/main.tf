# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# EXAMPLE DYNAMODB GLOBAL TABLES V2
#
# The following dynamodb table implements support for DynamoDB Global Tables V2 (version 2019.11.21):
# - https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/globaltables.V2.html
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

module "terraform-aws-dynamodb" {
  source  = "mineiros-io/dynamodb/aws"
  version = "~> 0.2.0"

  name         = "global"
  hash_key     = "MyKey"
  billing_mode = "PAY_PER_REQUEST"

  attributes = {
    MyKey = "S"
  }

  replica_region_names = ["eu-west-1"]
}

# ----------------------------------------------------------------------------------------------------------------------
# EXAMPLE PROVIDER CONFIGURATION
# ----------------------------------------------------------------------------------------------------------------------

provider "aws" {
  version = "~> 3.0"
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
