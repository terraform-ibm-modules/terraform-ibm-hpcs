#########################################################################################
# IBM Cloud Hyper Protect Crypto Services Provisioning, Initialization and Managing Keys
# Copyright 2020 IBM
#########################################################################################

resource "null_resource" "hpcs_init" {
  triggers = {
    CLOUDTKEFILES = var.tke_files_path
    INPUT_FILE    = file(var.input_file_name)
    HPCS_GUID     = var.hpcs_instance_guid
  }
  provisioner "local-exec" {
    when = create
    command = <<EOT
    python ${path.module}/../../../modules/ibm-hpcs-initialisation/scripts/init.py
        EOT
    environment = {
      CLOUDTKEFILES = var.tke_files_path
      INPUT_FILE    = file(var.input_file_name)
      HPCS_GUID     = var.hpcs_instance_guid
    }
  }
  provisioner "local-exec" {
    when = destroy
    command = <<EOT
    python ${path.module}/../../../modules/ibm-hpcs-initialisation/scripts/destroy.py
        EOT
    environment = {
      CLOUDTKEFILES = self.triggers.CLOUDTKEFILES
      INPUT_FILE    = self.triggers.INPUT_FILE
      HPCS_GUID     = self.triggers.HPCS_GUID
    }
  }
}

