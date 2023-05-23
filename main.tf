/********************************************************************
This file is used to implement the ROOT module.
*********************************************************************/

resource ibm_hpcs hpcs_instance {
    count = var.initialization_using_recovery_crypto_units ? 1 : 0
    location             = var.location
    name                 = var.name
    plan                 = var.plan
    units                = 2
    signature_threshold  = 1
    revocation_threshold = 1
    admins {
        name  = "admin1"
        key   = "/cloudTKE/1.sigkey"
        token = "<sensitive1234>"
    }
    admins {
        name  = "admin2"
        key   = "/cloudTKE/2.sigkey"
        token = "<sensitive1234>"
    }
}


resource "ibm_resource_instance" "hpcs_instance1" {
    count = var.initialization_using_recovery_crypto_units ? 0 : 1
    
    name              = var.service_name
    service           = "hs-crypto"
    location          = var.region
    plan              = var.plan
    resource_group_id = var.resource_group_id
    tags              = (var.tags != null ? var.tags : null)
    service_endpoints = (var.service_endpoints != null ? var.service_endpoints : null)
    parameters = {
        units = var.number_of_crypto_units
    }
}