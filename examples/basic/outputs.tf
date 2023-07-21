##############################################################################
# Outputs
##############################################################################

output "hpcs_name" {
  description = "HPCS instance name"
  value       = module.hpcs_instance.hpcs_name
}

output "hpcs_endpoints" {
  description = "HPCS instance endpoints"
  value       = module.hpcs_instance.endpoints
}
