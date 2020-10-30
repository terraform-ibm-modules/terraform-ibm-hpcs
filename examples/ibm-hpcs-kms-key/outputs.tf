#########################################################################################
# IBM Cloud Hyper Protect Crypto Services Provisioning, Initialization and Managing Keys
# Copyright 2020 IBM
#########################################################################################
output "kms-key" {
  value = module.ibm-hpcs-kms-key
}
