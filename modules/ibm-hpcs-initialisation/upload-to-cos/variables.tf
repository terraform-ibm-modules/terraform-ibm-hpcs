#########################################################################################
# IBM Cloud Hyper Protect Crypto Services Provisioning, Initialization and Managing Keys
# Copyright 2020 IBM
#########################################################################################


# COS Credentials
variable "api_key" {
  type        = string
  description = "api key of the COS bucket"
}
variable "cos_crn" {
  type        = string
  description = "COS instance CRN"
}
variable "endpoint" {
  type        = string
  description = "COS endpoint"
}
variable "bucket_name" {
  type        = string
  description = "COS bucket name"
}
# Path to which CLOUDTKEFILES has to be exported
variable "tke_files_path" {
  type        = string
  description = "Path to which tke files has to be exported"
}
variable "hpcs_instance_guid" {
  type        = string
  description = "HPCS Instance GUID"
}