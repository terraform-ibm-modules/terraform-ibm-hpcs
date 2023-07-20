/********************************************************************
This file is used to implement the HPCS module.
*********************************************************************/

locals {
  # tflint-ignore: terraform_unused_declarations
  validate_inputs = var.hsm_connector_id != null && var.auto_initialization_using_recovery_crypto_units == true ? tobool("Provided inputs are not correct. If hsm_conector_id is set to a value then auto_initialization_using_recovery_crypto_units can not be true.") : true
  # tflint-ignore: terraform_unused_declarations
  validate_region = var.auto_initialization_using_recovery_crypto_units == true ? (contains(["us-south", "us-east"], var.region) ? true : tobool("Currently us-south and us-east are the only supported regions for HPCS instance initialization using recovery crypto units.")) : true
  # tflint-ignore: terraform_unused_declarations
  validate_num_of_administrators = var.auto_initialization_using_recovery_crypto_units == true ? ((length(var.admins) >= 1 && length(var.admins) <= 8) ? true : tobool("At least one administrator is required for the instance crypto unit and you can set upto 8 adminsitrators.")) : true
  # tflint-ignore: terraform_unused_declarations
  validate_admins_and_threshold = var.auto_initialization_using_recovery_crypto_units == true ? ((length(var.admins) >= var.signature_threshold && length(var.admins) >= var.revocation_threshold) ? true : tobool("The adminstrators of the instance crypto units need to be equal to or greater than the threshold value.")) : true
  # tflint-ignore: terraform_unused_declarations
  validate_num_of_failover_units = var.auto_initialization_using_recovery_crypto_units == true ? (var.number_of_failover_units <= var.number_of_crypto_units ? true : tobool("Number of failover_units must be less than or equal to the number of operational crypto units")) : true
}

resource "ibm_hpcs" "hpcs_instance" {
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
    for_each = nonsensitive(var.admins != null ? var.admins : [])
    content {
      name  = admins.value["name"]
      key   = admins.value["key"]
      token = admins.value["token"]
    }
  }
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
}
