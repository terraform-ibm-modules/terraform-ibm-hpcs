##############################################################################
# Input Variables
##############################################################################

variable "resource_group_id" {
  type        = string
  description = "The resource group name where the Hyper Protect Crypto Service instance will be created."
}

variable "region" {
  type        = string
  description = "The region where you want to deploy your instance."
}

variable "name" {
  type        = string
  description = "The name to give the Hyper Protect Crypto Service instance. Max length allowed is 30 chars."
  validation {
    condition     = length(var.name) <= 30
    error_message = "Maximum length of service_name allowed is 30 chars"
  }
}

variable "plan" {
  type        = string
  description = "The name of the service plan that you choose for your Hyper Protect Crypto Service instance."
  default     = "standard"
  validation {
    condition     = contains(["standard"], var.plan)
    error_message = "Only the standard plan is supported currently"
  }
}

variable "auto_initialization_using_recovery_crypto_units" {
  type        = bool
  description = "Set to true if auto initialization using recovery crypto units is required."
  default     = false
}

variable "number_of_crypto_units" {
  type        = number
  description = "The number of operational crypto units for your service instance."
  default     = 2
  validation {
    condition     = contains([2, 3], var.number_of_crypto_units)
    error_message = "Allowed value of number_of_crypto_units is 2 or 3"
  }
}

variable "tags" {
  description = "Optional list of resource tags to apply to the HPCS instance."
  type        = list(string)
  default     = []
}

variable "signature_threshold" {
  type        = number
  description = "The number of administrator signatures that is required to execute administrative commands. Only used if auto_initialization_using_recovery_crypto_units is true"
  default     = 1
  validation {
    condition     = var.signature_threshold >= 1 && var.signature_threshold <= 8
    error_message = "Allowed values of signature_threshold is between 1 and 8"
  }
}

variable "revocation_threshold" {
  type        = number
  description = "The number of administrator signatures that is required to remove an administrator after you leave imprint mode. Only used if auto_initialization_using_recovery_crypto_units is true"
  default     = 1
  validation {
    condition     = var.revocation_threshold >= 1 && var.revocation_threshold <= 8
    error_message = "Allowed values of revocation_threshold is between 1 and 8"
  }
}

variable "signature_server_url" {
  type        = string
  description = "The URL and port number of the signing service. Required if you are using a third-party signing service to provide administrator signature keys. Only used if auto_initialization_using_recovery_crypto_units is true"
  default     = null
}

variable "admins" {
  type = list(object({
    name = string # max length: 30 chars
    key  = string # the absolute path and the file name of the signature key file if key files are created using TKE CLI and are not using a third-party signing service
    # if you are using a signing service, the key name is appended to a URI that will be sent to the signing service
    token = string # sensitive: the administrator password/token to authorize and access the corresponding signature key file
  }))
  default     = []
  sensitive   = true
  description = "A list of administrators for the instance crypto units. See [instructions](https://github.com/terraform-ibm-modules/terraform-ibm-hpcs#before-you-begin) to create administrator signature keys. You can set up to 8 administrators. Only used if auto_initialization_using_recovery_crypto_units is true"
}

variable "number_of_failover_units" {
  type        = number
  description = "The number of failover crypto units for your service instance. Default is 0 and cross-region high availability will not be enabled."
  default     = 2
  validation {
    condition     = contains([2, 3], var.number_of_failover_units)
    error_message = "Allowed values of failover_units is 2, 3."
  }
}

variable "service_endpoints" {
  type        = string
  description = "The service_endpoints to access your service instance. . Only used if auto_initialization_using_recovery_crypto_units is true. Can only be set to private-only if Terraform has access to the private endpoints. Default value is public-and-private."
  nullable    = false
  default     = "public-and-private"
  validation {
    condition     = contains(["public-and-private", "private-only"], var.service_endpoints)
    error_message = "Allowed values of service_endpoints are public-and-private and private-only"
  }
}

variable "hsm_connector_id" {
  type        = string
  description = "The HSM connector ID provided by IBM required for Hybrid HPCS. Available to selected customers only."
  default     = null
}
##############################################################################
