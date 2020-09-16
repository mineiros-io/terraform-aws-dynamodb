# ------------------------------------------------------------------------------
# AWS DYNAMODB TABLE
# ------------------------------------------------------------------------------

locals {
  read_capacity  = var.billing_mode == "PROVISIONED" ? var.read_capacity : null
  write_capacity = var.billing_mode == "PROVISIONED" ? var.write_capacity : null
  ttl_enabled    = var.ttl_attribute_name != null && var.ttl_enabled == null ? true : var.ttl_enabled
  table_tags     = merge(var.module_tags, var.table_tags)

  stream_enabled = var.stream_enabled == null && var.stream_view_type != null ? true : var.stream_enabled


  kms_type_default = var.kms_key_arn != null ? "CUSTOMER_MANAGED" : "AWS_OWNED"

  kms_type = var.kms_type != null ? var.kms_type : local.kms_type_default

  sse_by_mode = {
    "AWS_OWNED" = {
      enabled = false
    }
    "AWS_MANAGED" = {
      enabled = true
    }
    "CUSTOMER_MANAGED" = {
      enabled     = true
      kms_key_arn = var.kms_key_arn
    }
  }

  sse = local.sse_by_mode[local.kms_type]
}

resource "aws_dynamodb_table" "table" {
  count = var.module_enabled ? 1 : 0

  name = var.name

  hash_key  = var.hash_key
  range_key = var.range_key

  billing_mode   = var.billing_mode
  read_capacity  = local.read_capacity
  write_capacity = local.write_capacity

  stream_enabled   = local.stream_enabled
  stream_view_type = var.stream_view_type

  tags = local.table_tags

  server_side_encryption {
    enabled     = local.sse.enabled
    kms_key_arn = try(local.sse.kms_key_arn, null)
  }

  dynamic "attribute" {
    for_each = var.attributes

    content {
      name = attribute.key
      type = attribute.value
    }
  }

  dynamic "ttl" {
    for_each = var.ttl_attribute_name != null ? [true] : []

    content {
      enabled        = local.ttl_enabled
      attribute_name = var.ttl_attribute_name
    }
  }

  point_in_time_recovery {
    enabled = var.point_in_time_recovery_enabled
  }

  dynamic "replica" {
    for_each = var.replica_region_names

    content {
      region_name = replica.key
    }
  }

  dynamic "local_secondary_index" {
    for_each = var.local_secondary_indexes
    iterator = index

    content {
      name               = index.value.name
      range_key          = index.value.range_key
      projection_type    = index.value.projection_type
      non_key_attributes = try(index.value.non_key_attributes, null)
    }
  }

  dynamic "global_secondary_index" {
    for_each = var.global_secondary_indexes
    iterator = index

    content {
      name            = index.value.name
      hash_key        = index.value.hash_key
      projection_type = index.value.projection_type

      write_capacity = var.billing_mode == "PROVISIONED" ? try(index.value.write_capacity, null) : 0
      read_capacity  = var.billing_mode == "PROVISIONED" ? try(index.value.read_capacity, null) : 0

      range_key          = try(index.value.range_key, null)
      non_key_attributes = try(index.value.non_key_attributes, null)
    }
  }

  depends_on = [var.module_depends_on]
}
