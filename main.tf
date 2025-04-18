/********************************************************************
This file is used to implement the HPCS module.
*********************************************************************/

locals {
  admins_name_map = merge([for admin in var.base64_encoded_admins : { (admin.name) = { "name" = admin.name } }]...) # map created for non-sensitive value (admin name) only
  admins_map      = length(var.base64_encoded_admins) != 0 ? { for admin in var.base64_encoded_admins : admin.name => admin } : null
  admins = local.admins_map != null ? [
    for admin in var.base64_encoded_admins : {
      name  = admin.name
      key   = local_file.admin_files[admin.name].filename
      token = admin.token
    }
  ] : var.admins

  # Following is the fix for the issue https://github.com/terraform-ibm-modules/terraform-ibm-hpcs/issues/173
  temp_map               = (local.admins_name_map == null) ? {} : local.admins_name_map
  nonsensitive_value_map = (local.temp_map == {}) ? {} : nonsensitive(local.temp_map)
}

resource "ibm_hpcs" "hpcs_instance" {
  depends_on           = [local_file.admin_files]
  count                = var.auto_initialization_using_recovery_crypto_units ? 1 : 0
  location             = var.region
  resource_group_id    = var.resource_group_id
  name                 = var.name
  plan                 = var.plan
  tags                 = var.tags
  units                = var.number_of_crypto_units
  signature_threshold  = var.signature_threshold
  revocation_threshold = var.revocation_threshold
  failover_units       = var.number_of_failover_units
  signature_server_url = var.signature_server_url
  service_endpoints    = var.service_endpoints # Can only be set to private-only if Terraform has access to the private endpoints, ie. Terraform is run in IBM Cloud https://github.com/IBM-Cloud/terraform-provider-ibm/issues/4660

  dynamic "admins" {
    for_each = nonsensitive(local.admins != null ? local.admins : [])
    content {
      name  = admins.value["name"]
      key   = admins.value["key"]
      token = admins.value["token"]
    }
  }

  timeouts {
    create = var.create_timeout
    update = var.update_timeout
    delete = var.delete_timeout
  }
}

resource "local_file" "admin_files" {
  for_each       = (local.nonsensitive_value_map)
  content_base64 = local.admins_map[each.key].key
  filename       = "${path.module}/${each.key}.sigkey"
}

resource "ibm_resource_instance" "base_hpcs_instance" {
  count             = var.auto_initialization_using_recovery_crypto_units ? 0 : 1
  name              = var.name
  service           = "hs-crypto"
  location          = var.region
  plan              = var.plan
  resource_group_id = var.resource_group_id
  tags              = var.tags

  parameters = {
    units           = (var.hsm_connector_id != null) ? 3 : var.number_of_crypto_units # units - 3 is fixed for Hybrid-HPCS
    failover_units  = var.number_of_failover_units
    byohsm          = (var.hsm_connector_id != null) ? true : null # true for Hybrid-HPCS
    hsm_connector   = (var.hsm_connector_id != null) ? var.hsm_connector_id : null
    allowed_network = var.service_endpoints
  }

  timeouts {
    create = var.create_timeout
    update = var.update_timeout
    delete = var.delete_timeout
  }
}
