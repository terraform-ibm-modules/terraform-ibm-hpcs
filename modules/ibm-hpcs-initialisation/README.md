# Initialising HPCS Service Instances using Terraform Modules

This is a collection of modules that make it easier to initialise HPCS Instance IBM Cloud Platform:

* [ Download From Cos ](./download-from-cos) - It Downloads input json file from cos bucket.Json File contains Crypto Unit secrets.
* [ Initialisation Automation ](./hpcs-init) - It takes json file as input this module ll initialise HPCS Instance
* [ Upload TKE Files to COS ](./upload-to-cos) - It Uploads TKE Files sto COS Bucket.
* [Remove TKE Files](./remove-tkefiles) - It removes TKE Files and input from local.

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

### Download JsonFile From COS
```hcl
resource "null_resource" "download_from_cos" {

  provisioner "local-exec" {
    command = <<EOT
    python ${path.cwd}/../../../modules/ibm-hpcs-initialisation/scripts/download_from_cos.py
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
```
### Initialise HPCS instance using json file
```hcl

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

```
### Upload TKE Files to COS
```hcl
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
```
### Remove TKE Files from local machine
`Note:` This module will remove TKE files without having backup.. It is advisable to use this module after uploading TKE Files to COS

```hcl
resource "null_resource" "remove_tke_files" {
  triggers = {
    value = var.module_depends_on
  }
  provisioner "local-exec" {
    command = <<EOT
    python ${path.cwd}/../../../modules/ibm-hpcs-initialisation/scripts/remove_tkefiles.py
        EOT
    environment = {
      CLOUDTKEFILES   = var.tke_files_path
      INPUT_FILE_NAME = var.input_file_name
      HPCS_GUID       = var.hpcs_instance_guid
    }
  }
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