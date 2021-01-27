#########################################################################################
# IBM Cloud Hyper Protect Crypto Services Provisioning, Initialization and Managing Keys
# Copyright 2020 IBM
#########################################################################################

data "ibm_resource_group" "resource_group" {
  name = var.resource_group_name
}

module "ibm-hpcs-instance" {
  source = "../../modules/ibm-hpcs-instance"
  resource_group_id      = data.ibm_resource_group.resource_group.id
  service_name           = var.service_name
  region                 = var.region
  plan                   = var.plan
  tags                   = var.tags
  service_endpoints      = var.service_endpoints
  number_of_crypto_units = var.number_of_crypto_units
}

