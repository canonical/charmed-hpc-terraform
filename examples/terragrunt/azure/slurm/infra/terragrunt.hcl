# Create the Azure network infrastructure and the Juju model shared by the
# slurm stack. The NFS share and the model's machines live in this network.

include "root" {
  path = "../root.hcl"
}

# This module creates Azure network resources, so it also needs the azurerm
# provider (configured from the standard ARM_* environment variables).
generate "azurerm" {
  path      = "azurerm.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
    provider "azurerm" {
      features {}
    }
  EOF
}

inputs = {
  resource_group_name         = "charmed-hpc"
  virtual_network_name        = "charmed-hpc"
  network_security_group_name = "charmed-hpc"
  subnet_name                 = "charmed-hpc"
}

terraform {
  source = "../../../../..//examples/terragrunt/modules/azure/infra"
}
