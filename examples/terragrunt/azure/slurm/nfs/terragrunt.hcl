# Deploy the Azure Files-backed NFS share and mount it on every Slurm node.
# Runs after the slurm unit, whose outputs name the applications to integrate
# with.

include "root" {
  path = "../root.hcl"
}

# The azure/nfs module creates Azure storage resources, so it also needs the
# azurerm provider (configured from the standard ARM_* environment variables).
generate "azurerm" {
  path      = "azurerm.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
    provider "azurerm" {
      features {}
    }
  EOF
}

dependency "infra" {
  config_path = "../infra"

  mock_outputs = {
    model_uuid          = "00000000-0000-0000-0000-000000000000"
    resource_group_name = "mock-rg"
    subnet_info = {
      name                 = "mock-subnet"
      virtual_network_name = "mock-vnet"
    }
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate"]
}

dependency "slurm" {
  config_path = "../slurm"

  mock_outputs = {
    controller = {
      app_name = "slurmctld"
    }
    database = {
      app_name = "slurmdbd"
    }
    rest_api = {
      app_name = "slurmrestd"
    }
    kiosk = {
      app_name = "sackd"
    }
    compute_partitions = {
      default = { app_name = "default" }
      gpu     = { app_name = "gpu" }
    }
  }
  # Planning this unit needs real Azure resource names from infra, so mocks
  # are only allowed for init and validate.
  mock_outputs_allowed_terraform_commands = ["init", "validate"]
}

inputs = {
  model_uuid          = dependency.infra.outputs.model_uuid
  resource_group_name = dependency.infra.outputs.resource_group_name
  subnet_info         = dependency.infra.outputs.subnet_info

  # Mount the share on every Slurm node.
  applications = concat(
    [
      dependency.slurm.outputs.kiosk.app_name,
    ],
    [for partition in dependency.slurm.outputs.compute_partitions : partition.app_name],
  )
}

terraform {
  source = "../../../../..//examples/terragrunt/modules/azure/nfs"
}
