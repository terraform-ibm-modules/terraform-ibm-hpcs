##############################################################################
# Resource Group
##############################################################################

module "resource_group" {
  source  = "terraform-ibm-modules/resource-group/ibm"
  version = "1.0.5"
  # if an existing resource group is not set (null) create a new one using prefix
  resource_group_name          = var.resource_group == null ? "${var.prefix}-resource-group" : null
  existing_resource_group_name = var.resource_group
}

module "hpcs_instance" {
  source                                          = "../.."
  name                                            = "${var.prefix}-hpcs"
  region                                          = var.region
  tags                                            = var.resource_tags
  plan                                            = "standard"
  resource_group_id                               = module.resource_group.resource_group_id
  auto_initialization_using_recovery_crypto_units = false
  hsm_connector_id                                = var.hsm_connector_id
}
