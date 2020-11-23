#########################################################################################
# IBM Cloud Hyper Protect Crypto Services Provisioning, Initialization and Managing Keys
# Copyright 2020 IBM
#########################################################################################
data "ibm_resource_group" "resource_group" {
  name = var.resource_group_name
}

data "ibm_resource_instance" "hpcs_instance" {
  name              = var.service_name
  service           = "hs-crypto"
  location          = var.region
  resource_group_id = data.ibm_resource_group.resource_group.id

}

module "ibm-hpcs-kms-key" {
  source           = "terraform-ibm-modules/hpcs/ibm//modules/ibm-hpcs-kms-key/"
  instance_id      = data.ibm_resource_instance.hpcs_instance.guid
  name             = var.name
  standard_key     = var.standard_key
  force_delete     = var.force_delete
  endpoint_type    = var.endpoint_type
  key_material     = var.key_material
  encrypted_nonce  = var.encrypted_nonce
  iv_value         = var.iv_value
  expiration_date  = var.expiration_date
}
