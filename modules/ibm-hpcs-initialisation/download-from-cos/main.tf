#########################################################################################
# IBM Cloud Hyper Protect Crypto Services Provisioning, Initialization and Managing Keys
# Copyright 2020 IBM
#########################################################################################

resource "null_resource" "download_from_cos" {

  provisioner "local-exec" {
    command = <<EOT
    python ${path.module}/../../../modules/ibm-hpcs-initialisation/scripts/download_from_cos.py
        EOT
    environment = {
      API_KEY         = var.api_key
      COS_SERVICE_CRN = var.cos_crn
      ENDPOINT        = var.endpoint
      BUCKET          = var.bucket_name
      INPUT_FILE_NAME = var.input_file_name
    }
  }
}

