#########################################################################################
# IBM Cloud Hyper Protect Crypto Services Provisioning, Initialization and Managing Keys
# Copyright 2020 IBM
#########################################################################################

resource "ibm_kms_key" "key" {
  instance_id     = var.instance_id
  key_name        = var.name
  standard_key    = (var.standard_key != null ? var.standard_key : false)
  force_delete    = (var.force_delete != null ? var.force_delete : true)
  endpoint_type   = (var.endpoint_type != null ? var.endpoint_type : "public")
  payload         = (var.key_material != null ? var.key_material : null)
  encrypted_nonce = (var.encrypted_nonce != null ? var.encrypted_nonce : null)
  iv_value        = (var.iv_value != null ? var.iv_value : null)
  expiration_date = (var.expiration_date != null ? var.expiration_date : null)
}
