# ibm-hpcs

This example is used to provision and initialise hyper protect crypto services and also manage keys on hpcs instance.

## Terraform versions

Terraform 0.13 and above.

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

```terraform

module hpcs {
  source       = "../.."
  service_name = var.service_name
  admins       = var.admins
  key_name     = var.key_name
}

```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.13 |


## Providers

| Name | Version |
|------|---------|
| ibm | n/a |

## Inputs

| Name              | Description                                                                    | Type   |Default  | Required|
|-------------------|--------------------------------------------------------------------------------|--------|---------|---------|
| service_name             | A descriptive name used to identify the resource instance               |`string`| n/a     | yes     |
| admins                     | List of admin object. Please find details of `admins` object [here](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/hpcs#admins) |`set`   | n/a     | yes     |
| key_name                | Name of the key.                                                        |`string`| n/a     | yes     |


## Notes On Initialization:

* Current module supports provisioning and initialisation hpcs instance only on us regions (us-south and us-east)
* Set up your crypto unit administrator signature keys before running this module. find more details [here](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/hpcs#1-using-the-ibm-cloud-trusted-key-entry-tke-cli-plug-in)

