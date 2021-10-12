output "hpcs_guid" {
  value = local.instance_id
}
output "key_id" {
  value = ibm_kms_key.key[0].key_id
}
output "key_crn" {
  value = ibm_kms_key.key[0].id
}
output "key_alias" {
  value = ibm_kms_key_alias.key_alias[0].id
}
output "key_rings" {
  value = ibm_kms_key_rings.key_ring[0].id
}
output "hpcs_crn" {
  value = var.is_hpcs_instance_exist != true ? ibm_hpcs.hpcs_instance[0].crn : data.ibm_hpcs.hpcs_instance[0].crn
}
