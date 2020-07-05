# ------------------------------------------------------------------------------
# ENVIRONMENT VARIABLES
# Define these secrets as environment variables.
# ------------------------------------------------------------------------------

# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY

# ------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These variables must be set when using this module.
# ------------------------------------------------------------------------------

variable "name" {
  type        = string
  description = "(Required) The name of the table, this needs to be unique within a region."
}

variable "hash_key" {
  type        = string
  description = "(Required, Forces new resource) The attribute to use as the hash (partition) key. Must also be defined as an attribute."
}

variable "attributes" {
  type        = map(string)
  description = "(Required) List of nested attribute definitions. Only required for hash_key and range_key attributes."
}

# ------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These variables have defaults, but may be overridden.
# ------------------------------------------------------------------------------

variable "range_key" {
  type        = string
  description = "(Optional, Forces new resource) The attribute to use as the range (sort) key. Must also be defined as an attribute, see below."
  default     = null
}

variable "ttl_enabled" {
  type        = bool
  description = "Indicates whether ttl is enabled (true) or disabled (false). Defaults to true if ttl_attribute_name is set."
  default     = null
}

variable "ttl_attribute_name" {
  type        = string
  description = "(Optional) The name of the table attribute to store the TTL timestamp in."
  default     = null
}

variable "point_in_time_recovery_enabled" {
  type        = bool
  description = "Whether to enable point-in-time recovery - note that it can take up to 10 minutes to enable for new tables."
  default     = false
}

variable "stream_enabled" {
  type        = bool
  description = "(Optional) Indicates whether Streams are to be enabled (true) or disabled (false)."
  default     = false
}

variable "stream_view_type" {
  type        = string
  description = "(Optional) When an item in the table is modified, StreamViewType determines what information is written to the table's stream. Valid values are KEYS_ONLY, NEW_IMAGE, OLD_IMAGE, NEW_AND_OLD_IMAGES."
  default     = null
}

variable "replica_region_names" {
  type        = set(string)
  description = "(Optional) A set of region names of replicas (DynamoDB Global Tables V2 (version 2019.11.21) configuration)"
  default     = []
}

variable "billing_mode" {
  type        = string
  description = "(Optional) Controls how you are charged for read and write throughput and how you manage capacity. The valid values are PROVISIONED and PAY_PER_REQUEST."
  default     = "PROVISIONED"
}

variable "read_capacity" {
  type        = number
  description = "(Optional) The number of read units for this table. If the billing_mode is PROVISIONED, this field is required."
  default     = 5
}

variable "write_capacity" {
  type        = number
  description = "(Optional) The number of write units for this table. If the billing_mode is PROVISIONED, this field is required."
  default     = 5
}

variable "table_tags" {
  type        = map(string)
  description = "(Optional) A map of tags to populate on the created table."
  default     = {}
}

variable "kms_key_arn" {
  type        = string
  description = "(Optional) The ARN of the CMK that should be used for the AWS KMS encryption. This attribute should only be specified if the key is different from the default DynamoDB CMK, alias/aws/dynamodb."
  default     = null
}

variable "local_secondary_indexes" {
  type        = any
  description = "(Optional, Forces new resource) Describe an LSI on the table; these can only be allocated at creation so you cannot change this definition after you have created the resource."
  default     = []
}

# ------------------------------------------------------------------------------
# MODULE CONFIGURATION PARAMETERS
# These variables are used to configure the module.
# See https://medium.com/mineiros/the-ultimate-guide-on-how-to-write-terraform-modules-part-1-81f86d31f024
# ------------------------------------------------------------------------------
variable "module_enabled" {
  type        = bool
  description = "(Optional) Whether to create resources within the module or not. Default is true."
  default     = true
}

variable "module_tags" {
  description = "(Optional) A map of tags that will be applied to all created resources that accept tags. Tags defined with 'module_tags' can be overwritten by resource-specific tags."
  type        = map(string)
  default     = {}
}

variable "module_depends_on" {
  type        = any
  description = "(Optional) A list of external resources the module depends_on. Default is []."
  default     = []
}
