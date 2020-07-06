# ------------------------------------------------------------------------------
# OUTPUT CALCULATED VARIABLES (prefer full objects)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# OUTPUT ALL RESOURCES AS FULL OBJECTS
# ------------------------------------------------------------------------------

output "table" {
  description = "The dynamodb_table object."
  value       = try(aws_dynamodb_table.table[0], null)
}

# ------------------------------------------------------------------------------
# OUTPUT ALL INPUT VARIABLES
# ------------------------------------------------------------------------------

output "module_inputs" {
  description = "A map of all module arguments. Omitted optional arguments will be represented with their actual defaults."
  value = {
    name                           = var.name
    hash_key                       = var.hash_key
    attributes                     = var.attributes
    range_key                      = var.range_key
    ttl_attribute_name             = var.ttl_attribute_name
    point_in_time_recovery_enabled = var.point_in_time_recovery_enabled
    stream_view_type               = var.stream_view_type
    replica_region_names           = var.replica_region_names
    billing_mode                   = var.billing_mode
    kms_key_arn                    = var.kms_key_arn
    local_secondary_indexes        = var.local_secondary_indexes
    global_secondary_indexes       = var.global_secondary_indexes

    # computed defaults
    read_capacity  = local.read_capacity
    write_capacity = local.write_capacity
    ttl_enabled    = local.ttl_enabled
    table_tags     = local.table_tags
    stream_enabled = local.stream_enabled
  }
}

# ------------------------------------------------------------------------------
# OUTPUT MODULE CONFIGURATION
# ------------------------------------------------------------------------------
output "module_enabled" {
  description = "Whether the module is enabled"
  value       = var.module_enabled
}
