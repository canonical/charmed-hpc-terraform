# Copyright 2024-2025 Canonical Ltd.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Include the root configuration
include "root" {
  path = find_in_parent_folders("root.hcl")
}

# Specify the Terraform source
terraform {
  source = "."
}

# Generate Azure provider configuration
generate "provider_azurerm" {
  path      = "provider_azurerm.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "azurerm" {
  features {}
}
EOF
}

# Generate Terraform required providers configuration
generate "versions" {
  path      = "versions.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_providers {
    juju = {
      source  = "juju/juju"
      version = ">= 0.19.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.17"
    }
  }
  
  backend "local" {}
}
EOF
}
