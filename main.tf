# ------------------------------------------------------------------------------
# THIS IS A UPPERCASE MAIN HEADLINE
# And it continues with some lowercase information about the module
# We might add more than one line for additional information
# ------------------------------------------------------------------------------

locals {
  read_capacity  = var.billing_mode == "PROVISIONED" ? var.read_capacity : null
  write_capacity = var.billing_mode == "PROVISIONED" ? var.write_capacity : null
}

resource "aws_dynamodb_table" "table" {
  count = var.module_enabled ? 1 : 0

  name     = var.name
  hash_key = var.hash_key

  billing_mode   = var.billing_mode
  read_capacity  = local.read_capacity
  write_capacity = local.write_capacity

  tags = merge(var.module_tags, var.table_tags)

  server_side_encryption {
    enabled     = length(var.kms_key_arn) != null ? true : false
    kms_key_arn = var.kms_key_arn
  }

  dynamic "attribute" {
    for_each = var.attributes

    content {
      name = attribute.key
      type = attribute.value
    }
  }

  depends_on = [var.module_depends_on]
}
