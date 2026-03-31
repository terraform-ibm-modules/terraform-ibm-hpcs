# Hybrid-HPCS example

<!-- BEGIN SCHEMATICS DEPLOY HOOK -->
<p>
  <a href="https://cloud.ibm.com/schematics/workspaces/create?workspace_name=hpcs-hybrid-hpcs-example&repository=https://github.com/terraform-ibm-modules/terraform-ibm-hpcs/tree/main/examples/hybrid-hpcs">
    <img src="https://img.shields.io/badge/Deploy%20with%20IBM%20Cloud%20Schematics-0f62fe?style=flat&logo=ibm&logoColor=white&labelColor=0f62fe" alt="Deploy with IBM Cloud Schematics">
  </a><br>
  ℹ️ Ctrl/Cmd+Click or right-click on the Schematics deploy button to open in a new tab.
</p>
<!-- END SCHEMATICS DEPLOY HOOK -->

An example that creates the following infrastructure:

 - Create a new resource group if one is not passed in.
 - Create a new Hyper Protect Crypto Services instance that supports `Bring your own HSM`.

> Note: It requires a `hsm_connector_id` that will be provided by IBM. Currently this functionality is available to selected customers only.
