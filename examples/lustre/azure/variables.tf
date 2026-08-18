# Copyright 2026 Canonical Ltd.
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

# Connection details for the Juju controller to deploy into. When null, the
# provider falls back to its default behavior (JUJU_* environment variables
# or the currently logged-in controller). Terragrunt stacks set this from the
# controller unit's outputs; standalone usage can leave it unset.
variable "connection" {
  type = object({
    controller_addresses = string
    username             = string
    password             = string
    ca_certificate       = string
  })
  sensitive = true
  default   = null
}


variable "location" {
  description = "Azure region to deploy into. Must support the chosen VM size."
  type        = string
  default     = "eastus"
  nullable    = false
}

variable "server_units" {
  description = "Number of Lustre server VMs. One acts as MGS+MDS, the rest as OSSes."
  type        = number
  default     = 2
  nullable    = false
}

variable "server_vm_size" {
  description = "Azure VM size for the Lustre servers."
  type        = string
  default     = "Standard_HB120rs_v3"
  nullable    = false
}
