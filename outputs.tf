##############################################################################
# Outputs
##############################################################################

output "hpcs_name" {
  description = "HPCS instance name"
  value       = var.initialization_using_recovery_crypto_units ? ibm_hpcs.hpcs_instance[0].name : ibm_resource_instance.base_hpcs_instance[0].name
}

output "id" {
  description = "HPCS instance id"
  value       = var.initialization_using_recovery_crypto_units ? ibm_hpcs.hpcs_instance[0].id : ibm_resource_instance.base_hpcs_instance[0].id
}

output "guid" {
  description = "HPCS instance guid"
  value       = var.initialization_using_recovery_crypto_units ? ibm_hpcs.hpcs_instance[0].guid : ibm_resource_instance.base_hpcs_instance[0].guid
}

output "crn" {
  description = "HPCS instance crn"
  value       = var.initialization_using_recovery_crypto_units ? ibm_hpcs.hpcs_instance[0].crn : ibm_resource_instance.base_hpcs_instance[0].crn
}

##############################################################################
