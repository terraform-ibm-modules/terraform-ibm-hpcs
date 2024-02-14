terraform {
  required_version = ">= 1.3.0, < 1.6.0"

  required_providers {
    # Use "greater than or equal to" range in modules
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = ">= 1.49.0, < 2.0.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.4.0, < 3.0.0"
    }
  }
}
