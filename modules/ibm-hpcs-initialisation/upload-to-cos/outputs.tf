#########################################################################################
# IBM Cloud Hyper Protect Crypto Services Provisioning, Initialization and Managing Keys
# Copyright 2020 IBM
#########################################################################################
output "upload_to_cos" {
  value = null_resource.upload_to_cos.id
}