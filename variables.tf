
######################################
# HPCS Instance Variables
######################################
variable "is_hpcs_instance_exist" {
  type        = bool
  description = "Determines to if HPCS instance exists or not"
  default     = false
}
variable "failover_units" {
  type        = number
  description = "Number of failover units"
  default     = null
}
variable "location" {
  default     = "us-south"
  type        = string
  description = "Location of HPCS Instance. Allowed values are us-south and us-east"
  validation {
    condition     = var.location == "us-south" || var.location == "us-east"
    error_message = "Hpcs initialisation is only supported in us-south and us-east via terraform."
  }
}
variable "service_name" {
  type        = string
  description = "Name of HPCS Instance"
}
variable "plan" {
  default     = "standard"
  type        = string
  description = "Plan of HPCS Instance"
}
variable "resource_group_id" {
  type        = string
  description = "Resource group ID of instance"
  default     = null
}
variable "revocation_threshold" {
  type        = number
  description = "The number of administrator signatures that is required to remove an administrator after you leave imprint mode."
  default     = 1
}
variable "allowed_network_policy" {
  default     = "public-and-private"
  type        = string
  description = "Types of the service endpoints. Possible values are 'private-only', 'public-and-private'."
  validation {
    condition     = var.allowed_network_policy == "public-and-private" || var.allowed_network_policy == "private-only"
    error_message = "Possible values are `private-only` and `public-and-private`."
  }
}
variable "tags" {
  default     = null
  type        = set(string)
  description = "Tags for the KMS Instance"
}
variable "units" {
  type        = number
  description = "No of crypto units that has to be attached to the instance."
  default     = 2
}
variable "signature_threshold" {
  type        = number
  default     = 1
  description = "The number of administrator signatures "
}
variable "signature_server_url" {
  type        = string
  default     = null
  description = "Signature server URL"
}
variable "admins" {
  type = list(object({
    name  = string
    key   = string
    token = string
  }))
  description = "The list of administrators for the instance crypto units. "
}

######################################
# HPCS Key Variables
######################################
variable "key_name" {
  description = "Name of the Key"
  type        = string
}
variable "network_access_allowed" {
  description = "Endpoint type of the Key"
  type        = string
  default     = null
}
variable "standard_key_type" {
  description = "Determines if it is a standard key or not"
  default     = null
  type        = bool
}
variable "force_delete" {
  description = "Determines if it has to be force deleted"
  default     = null
  type        = bool
}
variable "encrypted_nonce" {
  description = "Encrypted_nonce of the Key"
  type        = string
  default     = null
}
variable "iv_value" {
  description = "Iv_value of the Key"
  type        = string
  default     = null
}
variable "key_material" {
  description = "key_material of the Key"
  type        = string
  default     = null
}
variable "expiration_date" {
  description = "Expiration_date of the Key"
  type        = string
  default     = null
}

######################################
# HPCS Key Policy Variables
######################################
variable "rotation" {
  description = "Rotaion policy"
  type        = any
  default     = []
}
variable "dual_auth_delete" {
  description = "Dual auth policy"
  type        = any
  default     = []
}

variable "key_alias" {
  type        = string
  default     = null
  description = "Name of Key alias that has to be created"
}
variable "key_ring_id" {
  type        = string
  default     = null
  description = "Key ring id that has to be created /  used in kms_key resource"
}

variable "create_key_ring" {
  default     = false
  type        = bool
  description = "If true, this module creates a key ring"
}