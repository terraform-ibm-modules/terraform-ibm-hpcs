# HPCS instance Module

This module is used to create a HPCS instance.

## Example Usage
```
resource "ibm_resource_instance" "hpcs_instance" {
  count             = (var.provision_instance == true ? 1 : 0)
  name              = var.service_name
  service           = "hs-crypto"
  plan              = var.plan
  resource_group_id = var.resource_group_id
  tags              = (var.tags != null ? var.tags : null)
  service_endpoints = (var.service_endpoints != null ? var.service_endpoints : null)
  location          = var.region
  parameters = {
    units = var.number_of_crypto_units
  }
}


```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name                     | Description                                                    | Type   |Default  |Required |
|--------------------------|----------------------------------------------------------------|--------|---------|---------|
| provision_instance       | Determines if the instance has to be created or not.           | `bool` | false   | yes     |
| service_name             | A descriptive name used to identify the resource instance      |`string`| n/a     | yes     |
| plan                     | The name of the plan type supported by service.                |`string`| n/a     | yes     |
| region                   | Target location or environment to create the resource instance |`string`| n/a     | yes     |
| resource_group_id        | Id of the resource group                                       |`string`| n/a     | yes     |
| tags                     | Tags for the database                                          |`set`   | n/a     | no      |
| service_endpoints        | Types of the service endpoints.                                |`string`| n/a     | no      |
| number_of_crypto_units   | Number of Crypto Units to be attached to instance              |`string`| n/a     | no      |

## Outputs
| Name          | Description                      |
|---------------|----------------------------------|
| hpcs_instance | The details of the HPCS Instance.|


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