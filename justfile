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

set unstable
set lists

project_dir := justfile_directory()
default_root_list := shell("find $1 -name '*.tf' -not -path '*/.terraform/*' -not -path '*/.terragrunt-cache/*' -not -path '*/terragrunt/*' -printf '%h\\n' | sort -u | tr '\\n' ' '", project_dir / "examples")
default_stack_list := shell("find $1 -mindepth 2 -maxdepth 3 -name terragrunt.hcl -not -path '*/.terragrunt-cache/*' -printf '%h\\n' | xargs -r -n1 dirname | sort -u | tr '\\n' ' '", project_dir / "examples/terragrunt")

# Prefer OpenTofu, fall back to Terraform.
tofu := which("tofu") || require("terraform")
terragrunt := require("terragrunt")

[private]
default:
    @just help

# Initialize Terraform roots and Terragrunt stacks
init:
    #!/usr/bin/env bash
    set -euo pipefail
    for root in {{ default_root_list }}; do
        {{ tofu }} -chdir=${root} init -backend=false
    done
    for stack in {{ default_stack_list }}; do
        {{ terragrunt }} run --all init --working-dir ${stack} --non-interactive
    done

# Check Terraform roots and Terragrunt stacks
check: init
    #!/usr/bin/env bash
    set -euo pipefail
    for root in {{ default_root_list }}; do
        {{ tofu }} -chdir=${root} fmt -check
        {{ tofu }} -chdir=${root} validate
    done
    for stack in {{ default_stack_list }}; do
        {{ terragrunt }} run --all validate --working-dir ${stack} --non-interactive
    done
    {{ terragrunt }} hcl format --check --non-interactive

# Apply formatting standards to project
fmt:
    #!/usr/bin/env bash
    set -euo pipefail
    just --fmt --unstable
    {{ tofu }} fmt -recursive
    {{ terragrunt }} hcl format --non-interactive

# Clean project directory
clean:
    #!/usr/bin/env bash
    set -euo pipefail
    find . -name .terraform -type d | xargs rm -rf
    find . -name .terraform.lock.hcl -type d | xargs rm -rf
    find . -name "terraform.tfstate*" -type f | xargs rm -rf
    find . -name .terragrunt-cache -type d | xargs rm -rf

# Show available recipes
help:
    @just --list --unsorted
