# terraform-ibm-hpcs

This modules is used to provision and initialise hyper protect crypto services and also manage keys on hpcs instance.

## Terraform versions

Terraform 0.13 and above.

## Usage

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
  source       = "./"
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
|is_hpcs_instance_exist | If true, this module using existing instance `service_name`|bool|false|no|
| failover_units                    | Number of fail over Crypto Units to be attached to instance     |`number`| n/a    | no      |
| location                   | Target location or environment to create the resource instance          |`string`| n/a     | yes     |
| service_name             | A descriptive name used to identify the resource instance               |`string`| n/a     | yes     |
| plan                     | The name of the plan type supported by service.                         |`string`| `standard`   | yes     |
| resource_group_id   | Id of the resource group                                              |`string`| n/a     | yes     |
| revocation_threshold   | The number of administrator signatures that is required to remove an administrator after you leave imprint mode.  |`number`| 1    | yes     |
| allowed_network_policy        | Types of the service endpoints.                                         |`string`| n/a     | no      |
| tags                     | Tags for the hpcs instance                                                   |`set`   | n/a     | no      |
| units                    | Number of Crypto Units to be attached to instance                       |`number`| n/a     | no      |
| signature_threshold           | The number of administrator signatures                             |`number`   | 1    | no      |
| signature_server_url          | "Signature server URL"                                        |`string`   | n/a     | no      |
| admins                     | List of admin object. Please find details of `admins` object [here](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/hpcs#admins) |`set`   | n/a     | yes     |
| key_name                | Name of the key.                                                        |`string`| n/a     | yes     |
| network_access_allowed        | Endpoint type of the Key                            |`string`| n/a     | no      |
| standard_key_type             | Determines if it has to be a standard key or root key                   |`bool`  | n/a   | no      |
| force_delete             | Determines if it has to be force deleted                                |`bool`  | false   | no      |
| key_material             | Key Payload.                                                            |`string`| n/a     | no      |
| encrypted_nonce          | Encrypted Nonce. Only for imported root key.                            |`string`| n/a     | no      |
| iv_value                 | IV Value. Only for imported root key.                                   |`string`| n/a     | no      |
| expiration_date          | Expination Date.                                                        |`string`| n/a     | no      |
| rotation          | Rotaion policy                                          |`set`| n/a     | no      |
| dual_auth_delete          | Dual auth policy                                                       |`set`| n/a     | no      |
| key_alias          | Name of Key alias that has to be created. If null, this module will not create any key alias.    |`string`| null    | no      |
| key_ring_id          | Key ring id that has to be created. If null, this module will not create any key ring                      |`string`| n/a     | no      |
| create_key_ring          | If true, this module creates a key ring  |`bool`| false    | no      |


## Notes On Initialization:

* Current module supports provisioning and initialisation hpcs instance only on us regions (us-south and us-east)
* Set up your crypto unit administrator signature keys before running this module. find more details [here](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/hpcs#1-using-the-ibm-cloud-trusted-key-entry-tke-cli-plug-in)

