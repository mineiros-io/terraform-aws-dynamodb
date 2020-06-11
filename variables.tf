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
  description = "(Required) List of nested attribute definitions."
}

# ------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These variables have defaults, but may be overridden.
# ------------------------------------------------------------------------------

variable "billing_mode" {
  type        = string
  description = "(Optional) billing_mode"
  default     = "PROVISIONED"
}

variable "read_capacity" {
  type        = number
  description = "(Optional) read_capacity"
  default     = 5
}

variable "write_capacity" {
  type        = number
  description = "(Optional) write_capacity"
  default     = 5
}

variable "tags" {
  type        = map(string)
  description = "(Optional) tags"
  default     = {}
}

variable "server_side_encryption" {
  type        = bool
  description = "(Optional) server_side_encryption"
  default     = true
}

variable "kms_key_arn" {
  type        = string
  description = "(Optional) kms_key_arn"
  default     = null
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

variable "module_depends_on" {
  type        = any
  description = "(Optional) A list of external resources the module depends_on. Default is []."
  default     = []
}
