# Managing HPCS Service Instances using Terraform Modules

This is a collection of modules that make it easier to provision and manage HPCS Instance IBM Cloud Platform:

* [Provisioning HPCS Instances](./examples/ibm-hpcs-instance)
* [Initialising HPCS Instance](./examples/init-using-local)
* [Managing Keys on HPCS Instance](./examples/ibm-hpcs-kms-key)

## HPCS Initialisation Architecture

![HPCS Architecture](./examples/ibm-hpcs-initialisation/references/diagrams/architechture.png?raw=true)
The figure above depicts the basic architecture of the IBM Cloud HPCS Init Terraform Automation.
The main components are..

- **COS Bucket**: HPCS Crypto unit credentials that stored in a Bucket as a json file will be taken as an input by `hpcs-init` terraform module and the secret tke-files that are obtained after execution of template will be stored back as zip file in cos bucket.
- **Terraform**: Reads the terraform configuration files and templates, execute the plan, and communicate with the plugins, manages the resource state and .tfstate file after apply.
- **IBM Cloud TKE Plugin**: The Python script that automates the initialisation process uses IBM CLOUD TKE Plugin

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

### Provision HPCS Instance


```hcl
module "ibm-hpcs-instance" {
  source = "../../modules/ibm-hpcs-instance"
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
  source             = "../../modules/ibm-hpcs-initialisation/hpcs-init"
  tke_files_path     = var.tke_files_path
  input_file_name    = var.input_file_name
  hpcs_instance_guid = data.ibm_resource_instance.hpcs_instance.guid
}
```

### Manage HPCS Keys
`Note:` To Manage Keys, Instance should be Initialized..

```hcl
module "ibm-hpcs-kms-key" {
  source           = "../../modules/ibm-hpcs-kms-key/"
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
| terraform | ~> 0.13 |
| OS | Mac/Linux |
| python | ~> 3.5 |
| pip | should supports python 3 |


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


Note:
* COS Credententials are required when `download_from_cos` and `upload_to_cos` null resources are used
* Cloud TKE Files will be downloaded at `tke_files_path`+` < GUID of the Service Instance >_tkefiles`. To perform any operation after initialisation on tkefiles outside terraform `CLOUDTKEFILES` should be exported to above mentioned path

## Pre-Requisites for Initialisation:
* python version 3.5 and above
* pip version 3 and above

``` hcl
  pip install pexpect
```
* `ibm-cos-sdk` package is required if initialisation is performed using objeck storage example..
``` hcl
pip install ibm-cos-sdk
```
* Login to IBM Cloud Account using cli
```hcl
ibmcloud login --apikey `<XXXYourAPIKEYXXXXX>` -r `<region>` -g `<resource_group>` -a `< cloud endpoint>
```
* Generate oauth-tokens `ibmcloud iam oauth-tokens`. This step should be done as and when token expires.
* To install tke plugin `ibmcloud plugin install tke`. find more info on tke plugin [here](https://cloud.ibm.com/docs/hs-crypto?topic=hs-crypto-initialize-hsm#initialize-crypto-prerequisites)

### Pre-commit Hooks

Run the following command to execute the pre-commit hooks defined in `.pre-commit-config.yaml` file

  `pre-commit run -a`

We can install pre-coomit tool using

  `pip install pre-commit`

### Detect Secret Hook

Used to detect secrets within a code base.

To create a secret baseline file run following command

```
detect-secrets scan --update .secrets.baseline
```

While running the pre-commit hook, if you encounter an error like

```
WARNING: You are running an outdated version of detect-secrets.
Your version: 0.13.1+ibm.27.dss
Latest version: 0.13.1+ibm.46.dss
See upgrade guide at https://ibm.biz/detect-secrets-how-to-upgrade
```

run below command

```
pre-commit autoupdate
```
which upgrades all the pre-commit hooks present in .pre-commit.yaml file.

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
