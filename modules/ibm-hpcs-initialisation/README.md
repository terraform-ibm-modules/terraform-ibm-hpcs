# Initialising HPCS Service Instances using Terraform Modules

This is a collection of modules that make it easier to initialise HPCS Instance IBM Cloud Platform:

* [ Download From Cos ](./download-from-cos) - It Downloads input json file from cos bucket.Json File contains Crypto Unit secrets.
* [ Initialisation Automation ](./hpcs-init) - It takes json file as input this module ll initialise HPCS Instance
* [ Upload TKE Files to COS ](./upload-to-cos) - It Uploads TKE Files sto COS Bucket.
* [Remove TKE Files](./remove-tkefiles) - It removes TKE Files and input from local.

## Terraform versions

Terraform 0.13.

## Usage

Full example is in [main.tf](main.tf)

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Run `terraform destroy` when you don't need these resources. This command zeroises the cryptounit.. to remove master keys and signature keys, Use following commands respectively `ibmcloud tke mk-rm` , `ibmcloud tke sigkey-rm`
Please refer `ibmcloud tke help` for more info.

## Example Usage

### Download JsonFile From COS
```hcl
module "download_from_cos" {
  source          = "modules/ibm-hpcs-initialisation/download-from-cos"
  api_key         = var.api_key
  cos_crn         = var.cos_crn
  endpoint        = var.endpoint
  bucket_name     = var.bucket_name
  input_file_name = var.input_file_name
}
```
### Initialise HPCS instance using json file
```hcl

module "hpcs_init" {
  source             = "modules/ibm-hpcs-initialisation/hpcs-init"
  depends_on         = [module.download_from_cos]
  tke_files_path     = var.tke_files_path
  input_file_name    = var.input_file_name
  hpcs_instance_guid = data.ibm_resource_instance.hpcs_instance.guid
}

```
### Upload TKE Files to COS
```hcl
module "upload_to_cos" {
  source             = "../../modules/ibm-hpcs-initialisation/upload-to-cos"
  depends_on         = [module.hpcs_init]
  api_key            = var.api_key
  cos_crn            = var.cos_crn
  endpoint           = var.endpoint
  bucket_name        = var.bucket_name
  tke_files_path     = var.tke_files_path
  hpcs_instance_guid = data.ibm_resource_instance.hpcs_instance.guid
}
```
### Remove TKE Files from local machine
`Note:` This module will remove TKE files without having backup.. It is advisable to use this module after uploading TKE Files to COS

```hcl
module "remove_tke_files" {
  source             = "../../../modules/ibm-hpcs-initialisation/remove-tkefiles"
  depends_on         = [module.upload_to_cos]
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
| terraform | ~> 0.13 |
| OS | Mac/Linux |
| python | ~> 3.5 |
| pip | should supports python 3 |

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

Note:
* COS Credententials are required when `download_from_cos` and `upload_to_cos` null resources are used
* Cloud TKE Files will be downloaded at `tke_files_path`+` < GUID of the Service Instance >_tkefiles`. To perform any operation after initialisation on tkefiles outside terraform `CLOUDTKEFILES` should be exported to above mentioned path



## Pre-Requisites for Initialisation:
* python version 3.5 and above
* pip version 3 and above

``` hcl
  pip install pexpect
```
`ibm-cos-sdk` package is required if initialisation is performed using objeck storage example..
``` hcl
pip install ibm-cos-sdk
```
* Login to IBM Cloud Account using cli
```hcl
ibmcloud login --apikey `<XXXYourAPIKEYXXXXX>` -r `<region>` -g `<resource_group>` -a `< cloud endpoint>
```
* Generate oauth-tokens `ibmcloud iam oauth-tokens`. This step should be done as and when token expires.
* To install tke plugin `ibmcloud plugin install tke`. find more info on tke plugin [here](https://cloud.ibm.com/docs/hs-crypto?topic=hs-crypto-initialize-hsm#initialize-crypto-prerequisites)

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

## References:
[Initializing  HPCS service instances with the IBM Cloud TKE CLI plug-in](https://cloud.ibm.com/docs/hs-crypto?topic=hs-crypto-initialize-hsm#load-master-keys)