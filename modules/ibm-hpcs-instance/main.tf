#########################################################################################
# IBM Cloud Hyper Protect Crypto Services Provisioning, Initialization and Managing Keys
# Copyright 2020 IBM
#########################################################################################

resource "ibm_resource_instance" "hpcs_instance" {
  name              = var.service_name
  service           = "hs-crypto"
  plan              = var.plan
  resource_group_id = var.resource_group_id
  tags              = (var.tags != null ? var.tags : null)
  service_endpoints = (var.service_endpoints != null ? var.service_endpoints : null)
  location          = var.region
  parameters = {
    units = var.number_of_crypto_units
  }
}
