##############################################################################
# Input Variables
##############################################################################

variable "resource_group_id" {
  type        = string
  description = "The resource group ID where the Hyper Protect Crypto Service instance will be created"
}

variable "region" {
 type        = string
 description = "The region where you want to deploy your instance."
 default     = "us-south"
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
 default     = ""
 validation {
    condition     = contains([2, 3], var.num_of_crypto_units)
    error_message = "Valid values of var.number_of_crypto_units are 2 or 3"
  }
}

variable "initialization_using_recovery_crypto_units" {
 type        = bool
 description = "Set to true if initialization using recovery crypto units is required"
 default     = false
}

##############################################################################
