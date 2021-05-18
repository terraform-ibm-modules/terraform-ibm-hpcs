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
# Input Json file
variable "input_file_name" {
  type        = string
  description = "Input json file name that is present in the cos-bucket or in the local"
  default     = "./references/input.json"
}
# Path to which CLOUDTKEFILES has to be exported
variable "tke_files_path" {
  type        = string
  description = "Path to which tke files has to be exported"
  default     = "/Users/kavya/tke-files"
}