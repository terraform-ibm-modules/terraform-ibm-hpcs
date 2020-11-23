#########################################################################################
# IBM Cloud Hyper Protect Crypto Services Provisioning, Initialization and Managing Keys
# Copyright 2020 IBM
#########################################################################################

# ------------------------------------------------------------------------------------------------------------
# #Intialization of the hpcs crypto service may be use some scripts and null_resource to intialize the service
# -------------------------------------------------------------------------------------------------------------
/* 
   Initilialising hpcs instance requires json file that containes all the creditials of admin and master keys as an input..
   This file can be fed as an input to the `hpcs_init` null resource in multiple ways out of which, 
   the present template supports file from IBM-Object-Storage Bucket or directly from the local.
   Use null resource blocks accordingly..
*/
data "ibm_resource_instance" "hpcs_instance" {
  name     = var.service_name
  service  = "hs-crypto"
  location = var.region
}

# This `hpcs_init` Initialises HPCS Instance by running all the tke command that are required for initialisation..
/* 
     This take the content of the json file as input and perform necessary operations
     The set of CLOUDTKEFILES that are obtained as an input is stored in the `tke_files_path` provided by user as a folder of secrets.
  */
module "hpcs_init" {
  source             = "terraform-ibm-modules/hpcs/ibm//modules/ibm-hpcs-initialisation/hpcs-init"
  tke_files_path     = var.tke_files_path
  input_file_name    = var.input_file_name
  hpcs_instance_guid = data.ibm_resource_instance.hpcs_instance.guid
}