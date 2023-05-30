/********************************************************************
This file is used to implement the ROOT module.
*********************************************************************/

//TO-DO
locals {
  //to check - You can set up to 8 administrators and the number needs to be equal to or greater than the thresholds that you specify.
  // failover_units must be less than or equal to the number of operational crypto units.

}
resource "ibm_hpcs" "hpcs_instance" {
  count                = var.initialization_using_recovery_crypto_units ? 1 : 0
  location             = var.region
  name                 = var.service_name
  plan                 = var.plan
  units                = var.number_of_crypto_units
  signature_threshold  = var.signature_threshold
  revocation_threshold = var.revocation_threshold

  dynamic "admins" {
    for_each = var.admins
    content {
      name = admins.value["name"]
      key = admins.value["key"]
      token = admins.value["token"]
    }
  }
}


resource "ibm_resource_instance" "base_hpcs_instance" {
  count             = var.initialization_using_recovery_crypto_units ? 0 : 1
  name              = var.service_name
  service           = "hs-crypto"
  location          = var.region
  plan              = var.plan
  resource_group_id = var.resource_group_id
  tags              = (var.tags != null ? var.tags : null)
  service_endpoints = (var.service_endpoints != null ? var.service_endpoints : null)
  parameters = {
    units                = var.number_of_crypto_units
    signature_threshold  = var.signature_threshold
    revocation_threshold = var.revocation_threshold
  }
}
