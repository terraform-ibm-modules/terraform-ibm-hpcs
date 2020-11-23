# Managing HPCS Service Instances using Terraform Modules

This is a collection of modules that make it easier to provision and manage HPCS Instance IBM Cloud Platform:

* [Provisioning HPCS Instances](./examples/ibm-hpcs-instance)
* [Initialising HPCS Instance](./examples/ibm-hpcs-initialisation)
* [Managing Keys on HPCS Instance](./examples/ibm-hpcs-kms-key)

## HPCS Initialisation Architecture

![HPCS Architecture](./examples/ibm-hpcs-initialisation/references/diagrams/architechture.png?raw=true)
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

### Provision HPCS Instance

Note: `provision_instance` will determine if the instance has to be provisioned or not. If `provision_instance` is true, count will be 1 and the instance will be provisioned..
```hcl
module "ibm-hpcs-instance" {
  source = "terraform-ibm-modules/hpcs/ibm//modules/ibm-hpcs-instance"

  provision_instance     = var.provision_instance
  resource_group_id      = data.ibm_resource_group.resource_group.id
  service_name           = var.service_name
  region                 = var.region
  plan                   = var.plan
  tags                   = var.tags
  service_endpoints      = var.service_endpoints
  number_of_crypto_units = var.number_of_crypto_units
}
```

### Initialize HPCS Instance

```hcl
module "hpcs_init" {
  source             = "terraform-ibm-modules/hpcs/ibm//modules/ibm-hpcs-initialisation/hpcs-init" 
  tke_files_path     = var.tke_files_path
  input_file_name    = var.input_file_name
  hpcs_instance_guid = data.ibm_resource_instance.hpcs_instance.guid
}
```

### Manage HPCS Keys
`Note:` To Manage Keys, Instance should be Initialized..

```hcl
module "ibm-hpcs-kms-key" {
  source           = "terraform-ibm-modules/hpcs/ibm//modules/ibm-hpcs-kms-key/"
  instance_id      = data.ibm_resource_instance.hpcs_instance.guid
  name             = var.name
  standard_key     = var.standard_key
  force_delete     = var.force_delete
  endpoint_type    = var.endpoint_type
  key_material     = var.key_material
  encrypted_nonce  = var.encrypted_nonce
  iv_value         = var.iv_value
  expiration_date  = var.expiration_date
}
```

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

| Name              | Description                                                                    | Type   |Default  | Required|
|-------------------|--------------------------------------------------------------------------------|--------|---------|---------|
| service_name             | A descriptive name used to identify the resource instance               |`string`| n/a     | yes     |
| plan                     | The name of the plan type supported by service.                         |`string`| n/a     | yes     |
| region                   | Target location or environment to create the resource instance          |`string`| n/a     | yes     |
| resource\_group_name     | Name of the resource group                                              |`string`| n/a     | yes     |
| tags                     | Tags for the database                                                   |`set`   | n/a     | no      |
| service_endpoints        | Types of the service endpoints.                                         |`string`| n/a     | no      |
| number_of_crypto_units   | Number of Crypto Units to be attached to instance                       |`string`| n/a     | no      |
| api_key                  | Api key of the COS bucket.                                              |`string`| n/a     | no      |
| cos_crn                  | COS instance CRN.                                                       |`string`| n/a     | no      |
| endpoint                 | COS endpoint.                                                           |`string`| n/a     | no      |
| bucket_name              | COS bucket name.                                                        |`string`| n/a     | no      |
| input_file_name          | Input json file name that is present in the cos-bucket or in the local. |`string`| n/a     | yes     |
| tke_files_path           | Path to which tke files has to be exported.                             |`string`| n/a     | yes     |
| key\_name                | Name of the key.                                                        |`string`| n/a     | yes     |
| name                     | Name of the Key                                                         |`string`| n/a     | no      |
| standard_key             | Determines if it has to be a standard key or root key                   |`bool`  | false   | no      |
| force_delete             | Determines if it has to be force deleted                                |`bool`  | false   | no      |
| endpoint_type            | public or private                                                       |`string`| `public`| no      |
| key_material             | Key Payload.                                                            |`string`| n/a     | no      |
| encrypted_nonce          | Encrypted Nonce. Only for imported root key.                            |`string`| n/a     | no      |
| iv_value                 | IV Value. Only for imported root key.                                   |`string`| n/a     | no      |
| expiration_date          | Expination Date.                                                        |`string`| n/a     | no      |


Note: COS Credententials are required when `download_from_cos` and `upload_to_cos` null resources are used


## Pre-Requisites for Initialisation:
* Login to IBM Cloud Account using cli `ibmcloud login --apikey= <Your IC Api Key> -a cloud.ibm.com`
* Target Resource group and region `ibmcloud target -g <resource group name>` `ibmcloud target -r <region>`
* Generate oauth-tokens `ibmcloud iam oauth-tokens`. This step should be done as and when token expires. 

## Notes On Initialization:
* The current script adds only one signature key admin.
* The signature key associated with the Admin name given in the json file will be selected as the current signature key.
* If number of master keys added is more than three, Master key registry will be `loaded`, `commited` and `setimmidiate` with last three added master keys.
* Please find the example json [here](./examples/ibm-hpcs-initialisation/references/input.json).
* Input can be fed in two ways either through local or through IBM Cloud Object Storage
* The input file is download from the cos bucket using `download_from_cos` null resource
* Secret TKE Files that are obtained after initialisation can be stored back in the COS Bucket as a Zip File using `upload_to_cos`null resource
* After uploading zip file to COS Bucket all the secret files and input file can be deleted from the local machine using `remove_tke_files` null resource.

## Future Enhancements:
* Automation of Pre-Requisites.
* Capability to add and select one or more admin.
* Integration with Hashicorp vault.