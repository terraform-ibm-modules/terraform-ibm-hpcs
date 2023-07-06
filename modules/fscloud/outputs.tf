##############################################################################
# Outputs
##############################################################################

output "hpcs_name" {
  description = "HPCS instance name"
  value       = module.ibm_hpcs.hpcs_name
}

output "id" {
  description = "HPCS instance id"
  value       = module.ibm_hpcs.id
}

output "guid" {
  description = "HPCS instance guid"
  value       = module.ibm_hpcs.guid
}

output "crn" {
  description = "HPCS instance crn"
  value       = module.ibm_hpcs.crn
}
