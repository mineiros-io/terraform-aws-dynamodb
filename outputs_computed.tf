data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

locals {
  region     = data.aws_region.current.name
  account_id = data.aws_caller_identity.current.account_id
  table_arn  = "arn:aws:dynamodb:${local.region}:${local.account_id}:table/${var.name}"
}

output "computed_arn" {
  description = "Computed table arn in the format: arn:aws:dynamodb:<region>:<account_id>:table/<name>"
  value       = var.module_enabled ? local.table_arn : null
}
