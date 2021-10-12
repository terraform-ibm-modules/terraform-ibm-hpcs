output "hpcs_guid" {
  value = local.instance_id
}
output "key_id" {
  value = ibm_kms_key.key.key_id
}
output "key_crn" {
  value = ibm_kms_key.key.id
}
output "key_alias" {
  value = ibm_kms_key_alias.key_alias.id
}
output "key_rings" {
  value = ibm_kms_key_rings.key_ring.id
}
output "hpcs_crn" {
  value = var.is_hpcs_instance_exist != true ? ibm_hpcs.hpcs_instance[0].crn : data.ibm_hpcs.hpcs_instance[0].crn
}
