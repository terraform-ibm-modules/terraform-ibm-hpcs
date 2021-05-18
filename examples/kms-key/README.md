# HPCS instance KMS Key Example

This example is used to create a keys on HPCS Instance
## Example Usage
```
module "ibm-hpcs-kms-key" {
  source           = "../../modules/ibm-hpcs-kms-key/"
  region           = var.region
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
## Inputs

| Name                     | Description                                                    | Type   |Default    |Required |
|--------------------------|----------------------------------------------------------------|:-------|:----------|:--------|
| resource\_group_name     | Name of the resource group                                     |`string`| n/a       | yes     |
| service_name             | A descriptive name used to identify the resource instance      |`string`| n/a       | yes     |
| region                   | Target location or environment to create the resource instance |`string`| n/a       | yes     |
| name                     | Name of the Key                                                |`string`| n/a       | no      |
| standard_key             | Determines if it has to be a standard key or root key          |`bool`  | false     | no      |
| force_delete             | Determines if it has to be force deleted                       |`bool`  | false     | no      |
| endpoint_type            | public or private                                              |`string`| `public`  | no      |
| key_material             | Key Payload.                                                   |`string`| n/a       | no      |
| encrypted_nonce          | Encrypted Nonce. Only for imported root key.                   |`string`| n/a       | no      |
| iv_value                 | IV Value. Only for imported root key.                          |`string`| n/a       | no      |
| expiration_date          | Expination Date.                                               |`string`| n/a       | no      |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Run `terraform destroy` when you don't need these resources.

 ## Note:
 All optional fields are given value `null` in varaible.tf file. User can configure the same by overwriting with appropriate values.