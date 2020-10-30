#########################################################################################
# IBM Cloud Hyper Protect Crypto Services Provisioning, Initialization and Managing Keys
# Copyright 2020 IBM
#########################################################################################
output "hpcs_init" {
  value = null_resource.hpcs_init.id
}