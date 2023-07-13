<!-- BEGIN MODULE HOOK -->

<!-- Update the title to match the module name and add a description -->
# IBM Cloud Hyper Protect Crypto Services
<!-- UPDATE BADGE: Update the link for the following badge-->
[![Stable (With quality checks)](https://img.shields.io/badge/Status-Stable%20(With%20quality%20checks)-green)](https://terraform-ibm-modules.github.io/documentation/#/badge-status)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)
[![latest release](https://img.shields.io/github/v/release/terraform-ibm-modules/terraform-ibm-hpcs?logo=GitHub&sort=semver)](https://github.com/terraform-ibm-modules/terraform-ibm-hpcs/releases/latest)
[![Renovate enabled](https://img.shields.io/badge/renovate-enabled-brightgreen.svg)](https://renovatebot.com/)
[![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release)

You can use this module to provision an IBM Cloud Hyper Protect Crypto Services (HPCS) instance.

The next step after provisioning an HPCS instance is to [initialize](https://cloud.ibm.com/docs/hs-crypto?topic=hs-crypto-get-started) the service to manage the keys. This module supports the following approaches:
- Provisioning and initializing the service by using the [recovery crypto units method](https://cloud.ibm.com/docs/hs-crypto?topic=hs-crypto-initialize-hsm-recovery-crypto-unit).
- Provisioning the service by other [approaches](https://cloud.ibm.com/docs/hs-crypto?topic=hs-crypto-uko-initialize-instance-mode) (for example, by using smart cards or  key part files). These approaches require manual steps after provisioning the service instance.
- Provisioning and initializing the service by using your own  hardware security module (HSM).


For more information, see [Components and concepts](https://cloud.ibm.com/docs/hs-crypto?topic=hs-crypto-uko-understand-concepts) and [About service instance initialization](https://cloud.ibm.com/docs/hs-crypto?topic=hs-crypto-introduce-service) in the Cloud Docs.


## Create Hyper Protect Crypto Services instance

### Usage to create the HPCS instance

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
  source                                          = "git::https://github.com/terraform-ibm-modules/terraform-ibm-hpcs?ref=main"
  resource_group_id                               = "000fb3134f214c3a9017554db4510f70" # pragma: allowlist secret
  region                                          = "us-south"
  service_name                                    = "my-hpcs-instance"
  tags                                            = ["tag1","tag2"]
  plan                                            = "standard"
  auto_initialization_using_recovery_crypto_units = false
}
```

There are multiple ways to initialize the service instance few of them include some manual steps, they are as follows:
 - [Initializing service instances by using smart cards and the Hyper Protect Crypto Services Management Utilities](https://cloud.ibm.com/docs/hs-crypto?topic=hs-crypto-initialize-hsm-management-utilities) : This approach gives you the highest security, which enables you to store and manage master key parts using smart cards.
 - [Initializing service instances by using key part files](https://cloud.ibm.com/docs/hs-crypto?topic=hs-crypto-initialize-hsm) : You can also initialize your service instance using master key parts that are stored in files on your local workstation. You can use this approach regardless of whether or not your service instance includes recovery crypto units.
 - [Initializing service instances using recovery crypto units](https://cloud.ibm.com/docs/hs-crypto?topic=hs-crypto-initialize-hsm-recovery-crypto-unit) : If you create your service instance in **Dallas (us-south) or Washington DC (us-east)** where the recovery crypto units are enabled, you can choose this approach where the master key is randomly generated within a recovery crypto unit and then exported to other crypto units.

## Create and initialize the Hyper Protect Crypto Services instance

### Before you begin: creating administrator signature keys

To initialize the instance with a third-party signing service, see [Using a signing service to manage signature keys for instance initialization](https://cloud.ibm.com/docs/hs-crypto?topic=hs-crypto-signing-service-signature-key&interface=ui) in the Cloud Docs.

Otherwise, if you are not using a third-party signing service, run the following commands that use the IBM Cloud TKE CLI plug-in
to generate admin signature keys.

* Install the [IBM Cloud CLI](https://cloud.ibm.com/docs/cli?topic=cli-install-ibmcloud-cli)

* Make sure you have a recent version the IBM Cloud Trusted Key Entry (TKE) CLI plug-in installed.
  * Run this command to install the plug-in:
    ```
    ibmcloud plugin install tke
    ```

    Or

  * Run this command to update your plug-in to the latest version with the following command:
    ```
    ibmcloud plugin update tke
    ```

* Set the environment variable `CLOUDTKEFILES` to specify the directory where you want to save signature key files.
  ```
  export CLOUDTKEFILES=<absolute path of directory>
  ```

* Login in to IBM CLoud CLI and make sure that you're logged in to the correct region and resource group where the service instance locates.
  ```
  ibmcloud login
  ibmcloud target -r <region> -g <resource_group>
  ```

* Run the following command to create administrator signature keys. The signature keys are created in the path specified in `CLOUDTKEFILES` and stored in files that are protected by passwords. Repeat this step to generate more keys.
  ```
  ibmcloud tke sigkey-add
  ```

:information_source: **Requirement:** Make sure that information about the administrator who is associated with the key is set in the `admins` input variable.


### Usage to create and initialize the HPCS instance

```hcl
provider "ibm" {
  ibmcloud_api_key = ""
  region           = "us-south"
}

module "hpcs" {
  # replace "main" with a GIT release version to lock into a specific release
  source                                          = "git::https://github.com/terraform-ibm-modules/terraform-ibm-hpcs?ref=main"
  resource_group_id                               = "000fb3134f214c3a9017554db4510f70" # pragma: allowlist secret
  region                                          = "us-south"
  service_name                                    = "my-hpcs-instance"
  tags                                            = ["tag1","tag2"]
  auto_initialization_using_recovery_crypto_units = true
  number_of_crypto_units                          = 3
  admins = [
    {
      name  = "admin1"
      key   = "/cloudTKE/1.sigkey"
      token = "sensitive1234"
    },
    {
      name  = "admin2"
      key   = "/cloudTKE/2.sigkey"
      token = "sensitive1234"
    }
  ]
}
```

## Required IAM access policies
You need the following permissions to run this module.

- Account Management
    - **Resource Group** service
        - `Viewer` platform access
- IAM Services
    - **Hyper Protect Crypto Services** service
        - `Editor` platform access
        - `Manager` service access

<!-- END MODULE HOOK -->
<!-- BEGIN EXAMPLES HOOK -->
## Examples

- [ Basic example](examples/basic)
- [ Complete example that creates and initialize HPCS instance](examples/complete)
- [ Financial Services Cloud profile](examples/fscloud)
- [ Hybrid-HPCS example](examples/hybrid-hpcs)
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
| <a name="input_admins"></a> [admins](#input\_admins) | A list of administrators for the instance crypto units. See [instructions](https://github.com/terraform-ibm-modules/terraform-ibm-hpcs#before-you-begin) to create administrator signature keys. You can set up to 8 administrators. Required if auto\_initialization\_using\_recovery\_crypto\_units set to true. | <pre>list(object({<br>    name = string # max length: 30 chars<br>    key  = string # the absolute path and the file name of the signature key file if key files are created using TKE CLI and are not using a third-party signing service<br>    # if you are using a signing service, the key name is appended to a URI that will be sent to the signing service<br>    token = string # sensitive: the administrator password/token to authorize and access the corresponding signature key file<br>  }))</pre> | `[]` | no |
| <a name="input_auto_initialization_using_recovery_crypto_units"></a> [auto\_initialization\_using\_recovery\_crypto\_units](#input\_auto\_initialization\_using\_recovery\_crypto\_units) | Set to true if auto initialization using recovery crypto units is required. | `bool` | `true` | no |
| <a name="input_hsm_connector_id"></a> [hsm\_connector\_id](#input\_hsm\_connector\_id) | The HSM connector ID provided by IBM required for Hybrid HPCS. Available to selected customers only. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | The name to give the Hyper Protect Crypto Service instance. Max length allowed is 30 chars. | `string` | n/a | yes |
| <a name="input_number_of_crypto_units"></a> [number\_of\_crypto\_units](#input\_number\_of\_crypto\_units) | The number of operational crypto units for your service instance. | `number` | `2` | no |
| <a name="input_number_of_failover_units"></a> [number\_of\_failover\_units](#input\_number\_of\_failover\_units) | The number of failover crypto units for your service instance. Default is 0 and cross-region high availability will not be enabled. | `number` | `0` | no |
| <a name="input_plan"></a> [plan](#input\_plan) | The name of the service plan that you choose for your Hyper Protect Crypto Service instance. | `string` | `"standard"` | no |
| <a name="input_region"></a> [region](#input\_region) | The region where you want to deploy your instance. | `string` | n/a | yes |
| <a name="input_resource_group_id"></a> [resource\_group\_id](#input\_resource\_group\_id) | The resource group name where the Hyper Protect Crypto Service instance will be created. | `string` | n/a | yes |
| <a name="input_revocation_threshold"></a> [revocation\_threshold](#input\_revocation\_threshold) | The number of administrator signatures that is required to remove an administrator after you leave imprint mode. Required if auto\_initialization\_using\_recovery\_crypto\_units set to true. | `number` | `1` | no |
| <a name="input_service_endpoints"></a> [service\_endpoints](#input\_service\_endpoints) | The service\_endpoints to access your service instance. Only used if auto\_initialization\_using\_recovery\_crypto\_units is true. Can only be set to private-only if Terraform has access to the private endpoints. Default value is public-and-private. | `string` | `"public-and-private"` | no |
| <a name="input_signature_server_url"></a> [signature\_server\_url](#input\_signature\_server\_url) | The URL and port number of the signing service. Required if auto\_initialization\_using\_recovery\_crypto\_units set to true and using a third-party signing service to provide administrator signature keys. Only used if auto\_initialization\_using\_recovery\_crypto\_units is true | `string` | `null` | no |
| <a name="input_signature_threshold"></a> [signature\_threshold](#input\_signature\_threshold) | The number of administrator signatures that is required to execute administrative commands. Required if auto\_initialization\_using\_recovery\_crypto\_units set to true. | `number` | `1` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Optional list of resource tags to apply to the HPCS instance. | `list(string)` | `[]` | no |

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
