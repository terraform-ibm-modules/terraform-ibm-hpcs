##############################################################################
# Resource Group
##############################################################################

# module "resource_group" {
#   source  = "terraform-ibm-modules/resource-group/ibm"
#   version = "1.0.5"
#   # if an existing resource group is not set (null) create a new one using prefix
#   resource_group_name          = var.resource_group == null ? "${var.prefix}-resource-group" : null
#   existing_resource_group_name = var.resource_group
# }

# module "hpcs_instance" {
#   source                                          = "../.."
#   name                                            = "${var.prefix}-hpcs"
#   region                                          = var.region
#   tags                                            = var.resource_tags
#   plan                                            = "standard"
#   resource_group_id                               = module.resource_group.resource_group_id
#   auto_initialization_using_recovery_crypto_units = false
#   hsm_connector_id                                = var.hsm_connector_id
#   #service_endpoints = "private-only"
# }

module "kms_key_ring" {
  source      = "terraform-ibm-modules/kms-key-ring/ibm"
  version     = "v2.1.0"
  instance_id = "e205b45e-3e52-426f-a38c-7e712e8d351c"
  key_ring_id = "${var.prefix}-key-ring"
}

module "kms_key_ring2" {
  source      = "terraform-ibm-modules/kms-key-ring/ibm"
  version     = "v2.1.0"
  instance_id = "e205b45e-3e52-426f-a38c-7e712e8d351c"
  key_ring_id = "${var.prefix}-key-ring2"
}

module "kms_key_ring3" {
  source      = "terraform-ibm-modules/kms-key-ring/ibm"
  version     = "v2.1.0"
  instance_id = "e205b45e-3e52-426f-a38c-7e712e8d351c"
  key_ring_id = "${var.prefix}-key-ring2"
}

module "kms_key_ring4" {
  source      = "terraform-ibm-modules/kms-key-ring/ibm"
  version     = "v2.1.0"
  instance_id = "e205b45e-3e52-426f-a38c-7e712e8d351c"
  key_ring_id = "${var.prefix}-key-ring4"
}

module "kms_key_ring5" {
  source      = "terraform-ibm-modules/kms-key-ring/ibm"
  version     = "v2.1.0"
  instance_id = "e205b45e-3e52-426f-a38c-7e712e8d351c"
  key_ring_id = "${var.prefix}-key-ring5"
}

module "kms_key_ring6" {
  source      = "terraform-ibm-modules/kms-key-ring/ibm"
  version     = "v2.1.0"
  instance_id = "e205b45e-3e52-426f-a38c-7e712e8d351c"
  key_ring_id = "${var.prefix}-key-ring6"
}

# module "kms_key_ring6" {
#   source      = "terraform-ibm-modules/kms-key-ring/ibm"
#   version     = "v2.1.0"
#   instance_id = "e205b45e-3e52-426f-a38c-7e712e8d351c"
#   key_ring_id = "${var.prefix}-key-ring6"
# }

data "ibm_kms_key_rings" "test" {
  instance_id = "e205b45e-3e52-426f-a38c-7e712e8d351c"
}

resource "null_resource" "cluster" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    command = "env"
  }
}

output "debug" {
  value = data.ibm_kms_key_rings.test
}