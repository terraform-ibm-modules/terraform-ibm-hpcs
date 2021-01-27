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
# This `download_from_cos` downloads json file cos-bucket..
/* 
     Json file should already be fed to cos bucket before accessing it via null resource.
     This block takes cos credentials as input and and dowloads file in the current directory.
     This block can be commented if user doesnt wish to download input from cos-bucket
  */
module "download_from_cos" {
  source          = "../../modules/ibm-hpcs-initialisation/download-from-cos"
  api_key         = var.api_key
  cos_crn         = var.cos_crn
  endpoint        = var.endpoint
  bucket_name     = var.bucket_name
  input_file_name = var.input_file_name
}

# This `hpcs_init` Initialises HPCS Instance by running all the tke command that are required for initialisation..
/* 
     This take the content of the json file as input and perform necessary operations
     The set of CLOUDTKEFILES that are obtained as an input is stored in the `tke_files_path` provided by user as a folder of secrets.
  */
module "hpcs_init" {
  source             = "../../modules/ibm-hpcs-initialisation/hpcs-init"
  depends_on = [module.download_from_cos]
  tke_files_path     = var.tke_files_path
  input_file_name    = var.input_file_name
  hpcs_instance_guid = data.ibm_resource_instance.hpcs_instance.guid
}
# This `upload_to_cos` uploads CLOUDTKEFILES that are present in `tke_files_path` as a zip file . 
/* 
     This block takes cos credentials as input and and uploads zip file
     This block can be commented if user doesnt wish to upload files to cos-bucket
     Different cos credentials can also be used to upload files
  */
module "upload_to_cos" {
  source             = "../../modules/ibm-hpcs-initialisation/upload-to-cos"
  depends_on = [module.hpcs_init]
  api_key            = var.api_key
  cos_crn            = var.cos_crn
  endpoint           = var.endpoint
  bucket_name        = var.bucket_name
  tke_files_path     = var.tke_files_path
  hpcs_instance_guid = data.ibm_resource_instance.hpcs_instance.guid
}
# This `remove_tke_files` removes CLOUDTKEFILES that are present in `tke_files_path` . 
/* 
     NOTE: This block has to be used only if user wish to delete CLOUDTKEFILES or the input file
  */
# module "remove_tke_files" {
#   source             = "../../../modules/ibm-hpcs-initialisation/remove-tkefiles"
#   depends_on         = [module.upload_to_cos]
#   tke_files_path     = var.tke_files_path
#   input_file_name    = var.input_file_name
#   hpcs_instance_guid = data.ibm_resource_instance.hpcs_instance.guid
# }
