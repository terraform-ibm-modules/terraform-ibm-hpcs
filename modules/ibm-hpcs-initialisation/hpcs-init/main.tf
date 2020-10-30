#########################################################################################
# IBM Cloud Hyper Protect Crypto Services Provisioning, Initialization and Managing Keys
# Copyright 2020 IBM
#########################################################################################

resource "null_resource" "hpcs_init" {
  triggers = {
    value = var.module_depends_on
  }
  provisioner "local-exec" {
    command = <<EOT
    python ${path.cwd}/../../../modules/ibm-hpcs-initialisation/scripts/init.py
        EOT
    environment = {
      CLOUDTKEFILES = var.tke_files_path
      INPUT_FILE    = file(var.input_file_name)
      HPCS_GUID     = var.hpcs_instance_guid
    }
  }
}

