# Basic example

An example that creates the following infrastructure:

 - Create a new resource group if one is not passed in.
 - Create a new Hyper Protect Crypto Services instance.

**Note:** This example doesn't initialize the service instance. There are multiple ways to initialize the service instance few of them include some manual steps, they are as follows:
 - [Initializing service instances by using smart cards and the Hyper Protect Crypto Services Management Utilities](https://cloud.ibm.com/docs/hs-crypto?topic=hs-crypto-initialize-hsm-management-utilities) : This approach gives you the highest security, which enables you to store and manage master key parts using smart cards.
 - [Initializing service instances by using key part files](https://cloud.ibm.com/docs/hs-crypto?topic=hs-crypto-initialize-hsm) : You can also initialize your service instance using master key parts that are stored in files on your local workstation. You can use this approach regardless of whether or not your service instance includes recovery crypto units.
 - [Initializing service instances using recovery crypto units](https://cloud.ibm.com/docs/hs-crypto?topic=hs-crypto-initialize-hsm-recovery-crypto-unit) : If you create your service instance in **Dallas (us-south) or Washington DC (us-east)** where the recovery crypto units are enabled, you can choose this approach where the master key is randomly generated within a recovery crypto unit and then exported to other crypto units.
