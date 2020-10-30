#########################################################################################
# IBM Cloud Hyper Protect Crypto Services Provisioning, Initialization and Managing Keys
# Copyright 2020 IBM
#########################################################################################

variable "service_name" {
  type        = string
  description = "Name of HPCS Instance"
}
variable "region" {
  type        = string
  description = "Location of HPCS Instance"
}
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

# Input Json file
variable "input_file_name" {
  type        = string
  description = "Input json file name that is present in the cos-bucket or in the local"
}
# Path to which CLOUDTKEFILES has to be exported
variable "tke_files_path" {
  type        = string
  description = "Path to which tke files has to be exported"
}