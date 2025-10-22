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

# Root terragrunt.hcl for examples
# This file contains common configuration shared across all examples

# Configure Terragrunt to automatically store tfstate files in the current directory
remote_state {
  backend = "local"
  config  = {}
}

# Generate provider configuration that is common across all examples
generate "provider_juju" {
  path      = "provider_juju.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "juju" {}
EOF
}

# Configure Terraform version constraint
terraform_version_constraint = ">= 1.0"
