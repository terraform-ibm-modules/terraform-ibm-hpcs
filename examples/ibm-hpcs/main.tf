module hpcs {
    source = "../../modules/ibm-hpcs"
    service_name =var.service_name
    admins = var.admins
    key_name =var.key_name
}

variable "service_name" {
  
}
variable "admins" {
  
}
variable "key_name" {
  
}
terraform {
  required_providers {
    ibm = {
      source = "IBM-Cloud/ibm"
    }
  }
}