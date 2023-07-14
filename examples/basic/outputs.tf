##############################################################################
# Outputs
##############################################################################

output "hpcs_name" {
  description = "HPCS instance name"
  value       = module.hpcs_instance.hpcs_name
}

output "hpcs_extensions" {
  description = "HPCS instance extensions"
  value       = module.hpcs_instance.extensions
}
