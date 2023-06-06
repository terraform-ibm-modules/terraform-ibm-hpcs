
module "resource_group" {
  source = "git::https://github.com/terraform-ibm-modules/terraform-ibm-resource-group.git?ref=v1.0.5"
  # if an existing resource group is not set (null) create a new one using prefix
  resource_group_name          = var.resource_group == null ? "${var.prefix}-resource-group" : null
  existing_resource_group_name = var.resource_group
}

module "ibm_hpcs" {
  source                                          = "../../"
  service_name                                    = "${var.prefix}-instance"
  resource_group_id                               = module.resource_group.resource_group_id
  region                                          = var.region
  tags                                            = var.resource_tags
  auto_initialization_using_recovery_crypto_units = true
  number_of_crypto_units                          = var.number_of_crypto_units
  admins                                          = var.admins
}
