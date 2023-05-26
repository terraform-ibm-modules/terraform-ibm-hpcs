##############################################################################
# Input Variables
##############################################################################

### to do - move the following vars in examples ####
# variable "ibmcloud_api_key" {
#   description = "The IBM Cloud platform API key needed to deploy IAM enabled resources."
#   type        = string
#   sensitive   = true
# }

variable "resource_group_id" {
  type        = string
  description = "The resource group ID where the Hyper Protect Crypto Service instance will be created"
  default     = "default"
}

# variable "prefix" {
#   description = "A unique identifier for resources. Must begin with a lowercase letter and end with a lowerccase letter or number. This prefix will be prepended to any resources provisioned by this template. Prefixes must be 16 or fewer characters."
#   type        = string
#   default     = "test-hpcs"
# }

###################################################

variable "region" {
  type        = string
  description = "The region where you want to deploy your instance."
  default     = "us-south"
  validation {
    condition     = contains(["us-south", "us-east"], var.region)
    error_message = "Currently, only us-south and us-east are the supported regions"
  }
}

variable "service_name" {
  type        = string
  description = "The name to give the Hyper Protect Crypto Service instance"
}

variable "plan" {
  type        = string
  description = "The name of the service plan that you choose for your Hyper Protect Crypto Service instance"
  default     = "standard"
  validation {
    condition     = contains(["standard"], var.plan)
    error_message = "Currently, only the standard plan is supported"
  }
}

variable "number_of_crypto_units" {
  type        = string
  description = "The number of operational crypto units for your service instance"
  default     = 2
  #  validation {
  #     condition     = contains([2, 3], var.number_of_crypto_units)
  #     error_message = "Valid value of var.number_of_crypto_units is 2 or 3"
  #   }
}

variable "tags" {
  description = "List of resource tags to apply to resources created by this module."
  type        = list(string)
  default     = []
}

variable "initialization_using_recovery_crypto_units" {
  type        = bool
  description = "Set to true if initialization using recovery crypto units is required"
  default     = false
}

variable "signature_threshold" {
  type        = number
  description = "The number of administrator signatures that is required to execute administrative commands"
  default     = 1
  validation {
    condition     = contains([1, 2, 3, 4, 5, 6, 7, 8], var.signature_threshold)
    error_message = "Valid values of var.signature_threshold is between 1 and 8"
  }
}

variable "revocation_threshold" {
  type        = number
  description = "The number of administrator signatures that is required to remove an administrator after you leave imprint mode"
  default     = 1
  validation {
    condition     = contains([1, 2, 3, 4, 5, 6, 7, 8], var.revocation_threshold)
    error_message = "Valid values of var.revocation_threshold is between 1 and 8"
  }
}

variable "signature_server_url" {
  type        = string
  description = "The URL and port number where the signing service. Required if you are using a third-party signing service to provide administrator signature keys"
  default     = ""
}

# variable "admins" {
#     type = list(object({
#           key   = string
#           name  = string
#           token = string
#     } ))
#     description = "The list of administrators for the instance crypto units"
# }

variable "failover_units" {
  type        = number
  description = "The number of failover crypto units for your service instance"
  default     = 0
}

variable "service_endpoints" {
  type        = string
  description = "The service_endpoints to access your service instance. Valid values are public-and-private and private-only"
  default     = "public-and-private"
}
##############################################################################
