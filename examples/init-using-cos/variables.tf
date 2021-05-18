#########################################################################################
# IBM Cloud Hyper Protect Crypto Services Provisioning, Initialization and Managing Keys
# Copyright 2020 IBM
#########################################################################################

variable "service_name" {
  type        = string
  description = "Name of HPCS Instance"
  default     = "Test-hpcs"
}
variable "region" {
  type        = string
  description = "Location of HPCS Instance"
  default     = "us-south"
}
# COS Credentials
variable "api_key" {
  type        = string
  description = "api key of the COS bucket"
  default     = "NE4c_IMZ3V4O0Gkh0zD6l0xjN8rZ0uMT14Mh-jAbsBX8"
}
variable "cos_crn" {
  type        = string
  description = "COS instance CRN"
  default     = "crn:v1:bluemix:public:cloud-object-storage:global:a/4448261269a14562b839e0a3019ed980:b072d7f5-a4be-4805-80e2-6c0b4940bdf0::"
}
variable "endpoint" {
  type        = string
  description = "COS endpoint"
  default     = "s3.us.cloud-object-storage.appdomain.cloud"
}
variable "bucket_name" {
  type        = string
  description = "COS bucket name"
  default     = "my-cos-bucket-xx"
}

# Input Json file
variable "input_file_name" {
  type        = string
  description = "Input json file name that is present in the cos-bucket or in the local"
  default     = "input.json"
}
# Path to which CLOUDTKEFILES has to be exported
variable "tke_files_path" {
  type        = string
  description = "Path to which tke files has to be exported"
  default     = "/Users/kavya/tke-files"
}