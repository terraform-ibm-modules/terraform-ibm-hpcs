variable "resource_group_name" {
  type        = string
  description = "Resource group of HPCS instance"
}
variable "service_name" {
  description = "Name of HPCS Service Instance in which key has to be created"
  type        = string
}
variable "region" {
  type        = string
  description = "Location of HPCS Instance"
}
variable "name" {
  description = "Name of the Key"
  type        = string
}
variable "standard_key" {
  description = "Determines if it is a standard key or not"
  default     = null
  type        = bool
}
variable "force_delete" {
  description = "Determines if it has to be force deleted"
  default     = null
  type        = bool
}
variable "endpoint_type" {
  description = "Endpoint type of the Key"
  type        = string
  default     = null
}
variable "encrypted_nonce" {
  description = "Encrypted_nonce of the Key. Only for imported root key"
  type        = string
  default     = null
}
variable "iv_value" {
  description = "Iv_value of the Key. Only for imported root key"
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
variable "ibmcloud_api_key" {
  type        = string
  description = "IBM Cloud API Key"
}