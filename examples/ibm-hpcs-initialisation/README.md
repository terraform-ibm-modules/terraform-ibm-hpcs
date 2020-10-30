# Initialising HPCS Service Instances using Terraform Modules

This Example template is used to initialise HPCS Instance IBM Cloud Platform:

* [ Init-Using-Cos](./init-using-cos) - Downloads input from cos bucket, Initialises HPCS Instance and Uploads TKE Files to COS.
* [ Init-using-Local](./init-using-local) - Given a json file as input this example ll initialise HPCS Instance
* Managing Keys on HPCS Instance - [ Key Management Service Resource](https://cloud.ibm.com/docs/terraform?topic=terraform-kp-resources#kms-key)

## HPCS Initialisation Architecture

![HPCS Architecture](references/diagrams/architechture.png?raw=true)
The figure above depicts the basic architecture of the IBM Cloud HPCS Init Terraform Automation.
The main components are..

- **COS Bucket**: HPCS Crypto unit credentials that stored in a Bucket as a json file will be taken as an input by `hpcs-init` terraform module and the secret tke-files that are obtained after execution of template will be stored back as zip file in cos bucket.
- **Terraform**: Reads the terraform configuration files and templates, execute the plan, and communicate with the plugins, manages the resource state and .tfstate file after apply.
- **IBM Cloud TKE Plugin**: The Python script that automates the initialisation process uses IBM CLOUD TKE Plugin

## Terraform versions

Terraform 0.12.

## Usage

Full example is in [main.tf](main.tf)

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Run `terraform destroy` when you don't need these resources.

## Example Usage

### Initialise HPCS Instance using COS
```hcl
module "download_from_cos" {
  source          = "../../../modules/ibm-hpcs-initialisation/download-from-cos"
  api_key         = var.api_key
  cos_crn         = var.cos_crn
  endpoint        = var.endpoint
  bucket_name     = var.bucket_name
  input_file_name = var.input_file_name
}
```
```hcl

module "hpcs_init" {
  source             = "../../../modules/ibm-hpcs-initialisation/hpcs-init"
  module_depends_on  = module.download_from_cos.download_from_cos
  tke_files_path     = var.tke_files_path
  input_file_name    = var.input_file_name
  hpcs_instance_guid = data.ibm_resource_instance.hpcs_instance.guid
}
```
```hcl
module "upload_to_cos" {
  source             = "../../../modules/ibm-hpcs-initialisation/upload-to-cos"
  module_depends_on  = module.hpcs_init.hpcs_init
  api_key            = var.api_key
  cos_crn            = var.cos_crn
  endpoint           = var.endpoint
  bucket_name        = var.bucket_name
  tke_files_path     = var.tke_files_path
  hpcs_instance_guid = data.ibm_resource_instance.hpcs_instance.guid
}
```


### Initialize HPCS Instance using local json file

```hcl
module "hpcs_init" {
  source             = "../../../modules/ibm-hpcs-initialisation/hpcs-init"
  tke_files_path     = var.tke_files_path
  input_file_name    = var.input_file_name
  hpcs_instance_guid = data.ibm_resource_instance.hpcs_instance.guid
}
```
`

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.12 |

## Providers

| Name | Version |
|------|---------|
| ibm | n/a |

## Inputs

| Name              | Description                                                             | Type     | Required |
|-------------------|-------------------------------------------------------------------------|----------|----------|
| api_key           | Api key of the COS bucket.                                              | `string` | No       |
| cos_crn           | COS instance CRN.                                                       | `string` | No       |
| endpoint          | COS endpoint.                                                           | `string` | No       |
| bucket_name       | COS bucket name.                                                        | `string` | No       |
| input_file_name   | Input json file name that is present in the cos-bucket or in the local. | `string` | Yes      |
| tke_files_path    | Path to which tke files has to be exported.                             | `string` | Yes      |
| key\_name         | Name of the key.                                                        | `string` | Yes      |

Note: COS Credententials are required when `download_from_cos` and `upload_to_cos` null resources are used


## Pre-Requisites for Initialisation:
* Login to IBM Cloud Account using cli `ibmcloud login --apikey= <Your IC Api Key> -a cloud.ibm.com`
* Target Resource group and region `ibmcloud target -g <resource group name>` `ibmcloud target -r <region>`
* Generate oauth-tokens `ibmcloud iam oauth-tokens`. This step should be done as and when token expires. 

## Notes On Initialization:
* The current script adds only one signature key admin.
* The signature key associated with the Admin name given in the json file will be selected as the current signature key.
* If number of master keys added is more than three, Master key registry will be `loaded`, `commited` and `setimmidiate` with last three added master keys.
* Please find the example json [here](references/input.json).
* Input can be fed in two ways either through local or through IBM Cloud Object Storage
* The input file is download from the cos bucket using `download_from_cos` null resource
* Secret TKE Files that are obtained after initialisation can be stored back in the COS Bucket as a Zip File using `upload_to_cos`null resource
* After uploading zip file to COS Bucket all the secret files and input file can be deleted from the local machine using `remove_tke_files` null resource.

## Future Enhancements:
* Automation of Pre-Requisites.
* Capability to add and select one or more admin.
* Integration with Hashicorp vault.