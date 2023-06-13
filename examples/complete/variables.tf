
variable "ibmcloud_api_key" {
  description = "The IBM Cloud platform API key needed to deploy IAM enabled resources."
  type        = string
  sensitive   = true
}

variable "resource_group" {
  type        = string
  description = "The resource group name where the Hyper Protect Crypto Service instance will be created."
  default     = null
}

variable "prefix" {
  description = "A unique identifier for resources. Must begin with a lowercase letter and end with a lowerccase letter or number. This prefix will be prepended to any resources provisioned by this template. Prefixes must be 16 or fewer characters."
  type        = string
  default     = "example-hpcs"
}

variable "resource_tags" {
  description = "Optional list of resource tags to apply to the HPCS instance."
  type        = list(string)
  default     = []
}

variable "region" {
  type        = string
  description = "The region where you want to deploy your instance. Supported regions are us-south and us-east."
  default     = "us-south"
}

variable "number_of_crypto_units" {
  type        = number
  description = "The number of operational crypto units for your Hyper Protect Crypto Service instance."
  default     = 2
}

variable "admins" {
  type = list(object({
    name = string # max length: 30 chars
    key  = string # the absolute path and the file name of the signature key file if key files are created using TKE CLI and are not using a third-party signing service
    # if you are using a signing service, the key name is appended to a URI that will be sent to the signing service
    token = string # sensitive: the administrator password/token to authorize and access the corresponding signature key file
  }))
  sensitive   = true
  description = "A list of administrators for the instance crypto units. You can set up to 8 administrators."
  default     = []
}
