# Profile for IBM Cloud Framework for Financial Services

This code is a version of the [parent root module](../../) that includes a default configuration that complies with the relevant controls from the [IBM Cloud Framework for Financial Services](https://cloud.ibm.com/docs/framework-financial-services?topic=framework-financial-services-about). See the [Example for IBM Cloud Framework for Financial Services](/examples/fscloud/) for logic that uses this module.

## Manual Actions
Due to the high level of security provided by IBM Hyper Protect Crypto Service, certain compliance-related tasks cannot currently be performed by Terraform.
As a result, several manual steps must be taken after deploying and initializing the instance to ensure compliance with the IBM Cloud Framework for Financial Services.

- Enable Dual Authorization Deletion https://cloud.ibm.com/docs/hs-crypto?topic=hs-crypto-manage-dual-auth
- Switch Allowed Network policy to `private-only` https://cloud.ibm.com/docs/hs-crypto?topic=hs-crypto-managing-network-access-policies (Note this can be set through terraform if `auto_initialization_using_recovery_crypto_units` is true)



<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ibm_hpcs"></a> [ibm\_hpcs](#module\_ibm\_hpcs) | ../../ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admins"></a> [admins](#input\_admins) | A list of administrators for the instance crypto units. See [instructions](https://github.com/terraform-ibm-modules/terraform-ibm-hpcs#before-you-begin) to create administrator signature keys. You can set up to 8 administrators. Only used if auto\_initialization\_using\_recovery\_crypto\_units is true | <pre>list(object({<br>    name = string # max length: 30 chars<br>    key  = string # the absolute path and the file name of the signature key file if key files are created using TKE CLI and are not using a third-party signing service<br>    # if you are using a signing service, the key name is appended to a URI that will be sent to the signing service<br>    token = string # sensitive: the administrator password/token to authorize and access the corresponding signature key file<br>  }))</pre> | `[]` | no |
| <a name="input_auto_initialization_using_recovery_crypto_units"></a> [auto\_initialization\_using\_recovery\_crypto\_units](#input\_auto\_initialization\_using\_recovery\_crypto\_units) | Set to true if auto initialization using recovery crypto units is required. | `bool` | `false` | no |
| <a name="input_hsm_connector_id"></a> [hsm\_connector\_id](#input\_hsm\_connector\_id) | The HSM connector ID provided by IBM required for Hybrid HPCS. Available to selected customers only. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | The name to give the Hyper Protect Crypto Service instance. Max length allowed is 30 chars. | `string` | n/a | yes |
| <a name="input_number_of_crypto_units"></a> [number\_of\_crypto\_units](#input\_number\_of\_crypto\_units) | The number of operational crypto units for your service instance. | `number` | `2` | no |
| <a name="input_number_of_failover_units"></a> [number\_of\_failover\_units](#input\_number\_of\_failover\_units) | The number of failover crypto units for your service instance. Default is 0 and cross-region high availability will not be enabled. | `number` | `2` | no |
| <a name="input_plan"></a> [plan](#input\_plan) | The name of the service plan that you choose for your Hyper Protect Crypto Service instance. | `string` | `"standard"` | no |
| <a name="input_region"></a> [region](#input\_region) | The region where you want to deploy your instance. | `string` | n/a | yes |
| <a name="input_resource_group_id"></a> [resource\_group\_id](#input\_resource\_group\_id) | The resource group name where the Hyper Protect Crypto Service instance will be created. | `string` | n/a | yes |
| <a name="input_revocation_threshold"></a> [revocation\_threshold](#input\_revocation\_threshold) | The number of administrator signatures that is required to remove an administrator after you leave imprint mode. Only used if auto\_initialization\_using\_recovery\_crypto\_units is true | `number` | `1` | no |
| <a name="input_service_endpoints"></a> [service\_endpoints](#input\_service\_endpoints) | The service\_endpoints to access your service instance. . Only used if auto\_initialization\_using\_recovery\_crypto\_units is true. Can only be set to private-only if Terraform has access to the private endpoints. Default value is public-and-private. | `string` | `"public-and-private"` | no |
| <a name="input_signature_server_url"></a> [signature\_server\_url](#input\_signature\_server\_url) | The URL and port number of the signing service. Required if you are using a third-party signing service to provide administrator signature keys. Only used if auto\_initialization\_using\_recovery\_crypto\_units is true | `string` | `null` | no |
| <a name="input_signature_threshold"></a> [signature\_threshold](#input\_signature\_threshold) | The number of administrator signatures that is required to execute administrative commands. Only used if auto\_initialization\_using\_recovery\_crypto\_units is true | `number` | `1` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Optional list of resource tags to apply to the HPCS instance. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_crn"></a> [crn](#output\_crn) | HPCS instance crn |
| <a name="output_guid"></a> [guid](#output\_guid) | HPCS instance guid |
| <a name="output_hpcs_name"></a> [hpcs\_name](#output\_hpcs\_name) | HPCS instance name |
| <a name="output_id"></a> [id](#output\_id) | HPCS instance id |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
