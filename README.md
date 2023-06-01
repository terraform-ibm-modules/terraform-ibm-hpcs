<!-- BEGIN MODULE HOOK -->

<!-- Update the title to match the module name and add a description -->
# IBM Cloud Hyper Protect Crypto Services
<!-- UPDATE BADGE: Update the link for the following badge-->
[![Incubating (Not yet consumable)](https://img.shields.io/badge/status-Incubating%20(Not%20yet%20consumable)-red)](https://terraform-ibm-modules.github.io/documentation/#/badge-status)
[![Build status](https://github.com/terraform-ibm-modules/terraform-ibm-hpcs/actions/workflows/ci.yml/badge.svg)](https://github.com/terraform-ibm-modules/terraform-ibm-hpcs/actions/workflows/ci.yml)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)
[![latest release](https://img.shields.io/github/v/release/terraform-ibm-modules/terraform-ibm-hpcs?logo=GitHub&sort=semver)](https://github.com/terraform-ibm-modules/terraform-ibm-hpcs/releases/latest)
[![Renovate enabled](https://img.shields.io/badge/renovate-enabled-brightgreen.svg)](https://renovatebot.com/)
[![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release)

You can use this module to provision and configure an IBM Cloud Hyper Protect Crypto Services instance.

## Usage

<!--
Add an example of the use of the module in the following code block.

Use real values instead of "var.<var_name>" or other placeholder values
unless real values don't help users know what to change.
-->

```hcl
provider "ibm" {
  ibmcloud_api_key = ""
  region           = "us-south"
}

module "hpcs" {
  # replace "main" with a GIT release version to lock into a specific release
  source            = ""git::https://github.com/terraform-ibm-modules/terraform-ibm-hpcs?ref=main""
  resource_group_id = "xxXXxxXXxXxXXXXxxXxxxXXXXxXXXXX"
  region            = "us-south"
  service_name     = "my-hpcs-instance"
}
```

## Required IAM access policies
You need the following permissions to run this module.

- Account Management
    - **Resource Group** service
        - `Viewer` platform access
- IAM Services
    - **Key Protect** service
        - `Editor` platform access
        - `Manager` service access
    - **Hyper Protect Crypto Services** service
        - `Editor` platform access
        - `Manager` service access

<!-- END MODULE HOOK -->
<!-- BEGIN EXAMPLES HOOK -->
## Examples

- [ Basic example](examples/basic)
- [ Example that creates and initialize HPCS instance](examples/create-and-initialize-hpcs)
<!-- END EXAMPLES HOOK -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | >= 1.49.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [ibm_hpcs.hpcs_instance](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/hpcs) | resource |
| [ibm_resource_instance.base_hpcs_instance](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/resource_instance) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admins"></a> [admins](#input\_admins) | A list of administrators for the instance crypto units. You can set up to 8 administrators. | <pre>list(object({<br>    name = string # max length: 30 chars<br>    key  = string # the absolute path and the file name of the signature key file if key files are created using TKE CLI and are not using a third-party signing service<br>    # if you are using a signing service, the key name is appended to a URI that will be sent to the signing service<br>    token = string # sensitive: the administrator password/token to authorize and access the corresponding signature key file<br>  }))</pre> | `[]` | no |
| <a name="input_initialization_using_recovery_crypto_units"></a> [initialization\_using\_recovery\_crypto\_units](#input\_initialization\_using\_recovery\_crypto\_units) | Set to true if initialization using recovery crypto units is required | `bool` | `false` | no |
| <a name="input_number_of_crypto_units"></a> [number\_of\_crypto\_units](#input\_number\_of\_crypto\_units) | The number of operational crypto units for your service instance | `number` | `2` | no |
| <a name="input_number_of_failover_units"></a> [number\_of\_failover\_units](#input\_number\_of\_failover\_units) | The number of failover crypto units for your service instance. Default is 0 if not specified and cross-region high availability will not be enabled. | `number` | `0` | no |
| <a name="input_plan"></a> [plan](#input\_plan) | The name of the service plan that you choose for your Hyper Protect Crypto Service instance | `string` | `"standard"` | no |
| <a name="input_region"></a> [region](#input\_region) | The region where you want to deploy your instance. | `string` | n/a | yes |
| <a name="input_resource_group_id"></a> [resource\_group\_id](#input\_resource\_group\_id) | The resource group name where the Hyper Protect Crypto Service instance will be created | `string` | n/a | yes |
| <a name="input_revocation_threshold"></a> [revocation\_threshold](#input\_revocation\_threshold) | The number of administrator signatures that is required to remove an administrator after you leave imprint mode | `number` | `1` | no |
| <a name="input_service_endpoints"></a> [service\_endpoints](#input\_service\_endpoints) | The service\_endpoints to access your service instance. Default value is public-and-private if not specified. | `string` | `"public-and-private"` | no |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | The name to give the Hyper Protect Crypto Service instance. Max length allowed is 30 chars. | `string` | n/a | yes |
| <a name="input_signature_server_url"></a> [signature\_server\_url](#input\_signature\_server\_url) | The URL and port number of the signing service. Required if you are using a third-party signing service to provide administrator signature keys | `string` | `""` | no |
| <a name="input_signature_threshold"></a> [signature\_threshold](#input\_signature\_threshold) | The number of administrator signatures that is required to execute administrative commands | `number` | `1` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Optional list of resource tags to apply to resources created | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_crn"></a> [crn](#output\_crn) | HPCS instance crn |
| <a name="output_guid"></a> [guid](#output\_guid) | HPCS instance guid |
| <a name="output_hpcs_name"></a> [hpcs\_name](#output\_hpcs\_name) | HPCS instance name |
| <a name="output_id"></a> [id](#output\_id) | HPCS instance id |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- BEGIN CONTRIBUTING HOOK -->

<!-- Leave this section as is so that your module has a link to local development environment set up steps for contributors to follow -->
## Contributing

You can report issues and request features for this module in GitHub issues in the module repo. See [Report an issue or request a feature](https://github.com/terraform-ibm-modules/.github/blob/main/.github/SUPPORT.md).

To set up your local development environment, see [Local development setup](https://terraform-ibm-modules.github.io/documentation/#/local-dev-setup) in the project documentation.
<!-- Source for this readme file: https://github.com/terraform-ibm-modules/common-dev-assets/tree/main/module-assets/ci/module-template-automation -->
<!-- END CONTRIBUTING HOOK -->
