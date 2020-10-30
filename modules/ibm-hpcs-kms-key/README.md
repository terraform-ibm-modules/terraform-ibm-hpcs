# HPCS instance KMS Key Module

This module is used to create a keys on HPCS Instance
## Example Usage
```
resource "ibm_kms_key" "key" {
  instance_id     = var.instance_id
  key_name        = var.name
  standard_key    = (var.standard_key != null ? var.standard_key : false)
  force_delete    = (var.force_delete != null ? var.force_delete : true)
  endpoint_type   = (var.endpoint_type != null ? var.endpoint_type : "public")
  payload         = (var.key_material != null ? var.key_material : null)
  encrypted_nonce = (var.encrypted_nonce != null ? var.encrypted_nonce : null)
  iv_value        = (var.iv_value != null ? var.iv_value : null)
  expiration_date = (var.expiration_date != null ? var.expiration_date : null)
}

```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name                     | Description                                                    | Type   |Default    |Required |
|--------------------------|----------------------------------------------------------------|:-------|:----------|:--------|
| resource\_group_name     | Name of the resource group                                     |`string`| n/a       | yes     |
| instance_id              | A Id used to identify the resource instance                    |`string`| n/a       | yes     |
| name                     | Name of the Key                                                |`string`| n/a       | no      |
| standard_key             | Determines if it has to be a standard key or root key          |`bool`  | false     | no      |
| force_delete             | Determines if it has to be force deleted                       |`bool`  | false     | no      |
| endpoint_type            | public or private                                              |`string`| `public`  | no      |
| key_material             | Key Payload.                                                   |`string`| n/a       | no      |
| encrypted_nonce          | Encrypted Nonce. Only for imported root key.                   |`string`| n/a       | no      |
| iv_value                 | IV Value. Only for imported root key.                          |`string`| n/a       | no      |
| expiration_date          | Expination Date.                                               |`string`| n/a       | no      |

## Outputs
| Name         | Description     |
|--------------|-----------------|
| key          | KMS Key Details.|

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