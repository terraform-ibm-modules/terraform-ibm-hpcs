#########################################################################################
# IBM Cloud Hyper Protect Crypto Services Provisioning, Initialization and Managing Keys
# Copyright 2020 IBM
#########################################################################################
output "remove_tke_files" {
  value = null_resource.remove_tke_files.id
}