#########################################################################################
# IBM Cloud Hyper Protect Crypto Services Provisioning, Initialization and Managing Keys
# Copyright 2020 IBM
#########################################################################################

resource "null_resource" "upload_to_cos" {
  triggers = {
    value = var.module_depends_on
  }
  provisioner "local-exec" {
    command = <<EOT
    python ${path.cwd}/../../../modules/ibm-hpcs-initialisation/scripts/upload_to_cos.py
        EOT
    environment = {
      API_KEY         = var.api_key
      COS_SERVICE_CRN = var.cos_crn
      ENDPOINT        = var.endpoint
      BUCKET          = var.bucket_name
      CLOUDTKEFILES   = var.tke_files_path
      HPCS_GUID       = var.hpcs_instance_guid
    }
  }
}
