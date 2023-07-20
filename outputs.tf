##############################################################################
# Outputs
##############################################################################

output "hpcs_name" {
  description = "HPCS instance name"
  value       = var.auto_initialization_using_recovery_crypto_units ? ibm_hpcs.hpcs_instance[0].name : ibm_resource_instance.base_hpcs_instance[0].name
}

output "id" {
  description = "HPCS instance id"
  value       = var.auto_initialization_using_recovery_crypto_units ? ibm_hpcs.hpcs_instance[0].id : ibm_resource_instance.base_hpcs_instance[0].id
}

output "guid" {
  description = "HPCS instance guid"
  value       = var.auto_initialization_using_recovery_crypto_units ? ibm_hpcs.hpcs_instance[0].guid : ibm_resource_instance.base_hpcs_instance[0].guid
}

output "crn" {
  description = "HPCS instance crn"
  value       = var.auto_initialization_using_recovery_crypto_units ? ibm_hpcs.hpcs_instance[0].crn : ibm_resource_instance.base_hpcs_instance[0].crn
}

output "endpoints" {
  description = "HPCS instance endpoints"
  value       = var.auto_initialization_using_recovery_crypto_units ? ibm_hpcs.hpcs_instance[0].extensions : ibm_resource_instance.base_hpcs_instance[0].extensions
}

##############################################################################
