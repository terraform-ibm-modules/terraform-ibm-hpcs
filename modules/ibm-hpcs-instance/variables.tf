#########################################################################################
# IBM Cloud Hyper Protect Crypto Services Provisioning, Initialization and Managing Keys
# Copyright 2020 IBM
#########################################################################################

variable "resource_group_id" {
  type        = string
  description = "Resource group ID of instance"
}

variable "provision_instance" {
  type        = bool
  default     = false
  description = "Determines if the instance has to be created or not"
}

variable "service_name" {
  type        = string
  description = "Name of HPCS Instance"
}
variable "region" {
  type        = string
  description = "Location of HPCS Instance"
}
variable "plan" {
  default     = null
  type        = string
  description = "Plan of HPCS Instance"
}
variable "service_endpoints" {
  default     = null
  type        = string
  description = "Types of the service endpoints. Possible values are 'public', 'private', 'public-and-private'."
}
variable "tags" {
  default     = null
  type        = set(string)
  description = "Tags for the cms"
}
variable "number_of_crypto_units" {
  type        = number
  description = "No of crypto units that has to be attached to the instance."
}
variable "ibmcloud_api_key" {
  type        = string
  description = "IBM Cloud API Key"
}