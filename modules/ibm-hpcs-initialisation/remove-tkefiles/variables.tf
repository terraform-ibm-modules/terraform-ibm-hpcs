#########################################################################################
# IBM Cloud Hyper Protect Crypto Services Provisioning, Initialization and Managing Keys
# Copyright 2020 IBM
#########################################################################################

variable "module_depends_on" {
  description = "module_depends_on"
  type        = string
}
# Path to which CLOUDTKEFILES has to be exported
variable "tke_files_path" {
  type        = string
  description = "Path to which tke files has to be exported"
}
# Input Json file
variable "input_file_name" {
  type        = string
  description = "Input json file name that is present in the cos-bucket or in the local"
}
variable "hpcs_instance_guid" {
  type        = string
  description = "HPCS Instance GUID"
}