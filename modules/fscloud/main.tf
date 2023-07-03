
module "ibm_hpcs" {
  source                                          = "../../"
  name                                            = var.name
  resource_group_id                               = var.resource_group_id
  region                                          = var.region
  tags                                            = var.tags
  auto_initialization_using_recovery_crypto_units = var.auto_initialization_using_recovery_crypto_units
  number_of_crypto_units                          = var.number_of_crypto_units
  number_of_failover_units                        = var.number_of_failover_units
  service_endpoints                               = var.service_endpoints
  revocation_threshold                            = var.revocation_threshold
  signature_threshold                             = var.signature_threshold
  signature_server_url                            = var.signature_server_url
  admins                                          = var.admins
  hsm_connector_id                                = var.hsm_connector_id

}
