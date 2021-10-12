#########################################################################################
# IBM Cloud Hyper Protect Crpto Service Provisioning and Managing Keys
# Copyright 2021 IBM
#########################################################################################

resource "ibm_hpcs" "hpcs_instance" {
  count                = var.is_hpcs_instance_exist != true ? 1 : 0
  failover_units       = var.failover_units
  location             = var.location
  name                 = var.service_name
  plan                 = var.plan
  resource_group_id    = var.resource_group_id
  revocation_threshold = var.revocation_threshold
  service_endpoints    = (var.allowed_network_policy != null ? var.allowed_network_policy : "public-and-private")
  units                = var.units
  signature_threshold  = var.signature_threshold
  signature_server_url = var.signature_server_url
  tags                 = var.tags
  dynamic "admins" {
    for_each = var.admins
    content {
      name  = admins.value.name
      key   = admins.value.key
      token = admins.value.token
    }
  }
}
data "ibm_hpcs" "hpcs_instance" {
  count             = var.is_hpcs_instance_exist != true ? 0 : 1
  name              = var.service_name
  resource_group_id = var.resource_group_id
  location          = var.location
}
locals {
  instance_id = var.is_hpcs_instance_exist != true ? ibm_hpcs.hpcs_instance[0].guid : data.ibm_hpcs.hpcs_instance[0].guid
}

resource "ibm_kms_key" "key" {
  count = var.key_name !=null ? 1 :0
  instance_id     = local.instance_id
  key_name        = var.key_name
  standard_key    = (var.standard_key_type != null ? var.standard_key_type : false)
  force_delete    = (var.force_delete != null ? var.force_delete : false)
  endpoint_type   = (var.network_access_allowed != null ? var.network_access_allowed : "public")
  payload         = (var.key_material != null ? var.key_material : null)
  encrypted_nonce = (var.encrypted_nonce != null ? var.encrypted_nonce : null)
  iv_value        = (var.iv_value != null ? var.iv_value : null)
  expiration_date = (var.expiration_date != null ? var.expiration_date : null)
}
resource "ibm_kms_key_policies" "keyPolicy" {
  count         = var.rotation == [] && var.dual_auth_delete == [] ? 0 : 1
  instance_id   = local.instance_id
  key_id        = ibm_kms_key.key[0].key_id
  endpoint_type = (var.network_access_allowed != null ? var.network_access_allowed : "public")
  dynamic "rotation" {
    for_each = var.rotation
    content {
      interval_month = lookup(rotation.value, "interval_month", null)
    }
  }
  dynamic "dual_auth_delete" {
    for_each = var.dual_auth_delete
    content {
      enabled = lookup(dual_auth_delete.value, "enabled", null)
    }
  }
}
resource "ibm_kms_key_alias" "key_alias" {
  count         = var.key_alias != null ? 1 : 0
  instance_id   = local.instance_id
  alias         = var.key_alias
  key_id        = ibm_kms_key.key[0].key_id
  endpoint_type = (var.network_access_allowed != null ? var.network_access_allowed : "public")
}
resource "ibm_kms_key_rings" "key_ring" {
  count         = var.key_ring_id != null ? 1 : 0
  instance_id   = local.instance_id
  key_ring_id   = var.key_ring_id
  endpoint_type = (var.network_access_allowed != null ? var.network_access_allowed : "public")
}
