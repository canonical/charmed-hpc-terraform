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

variable "base" {
  description = "Base operating system to deploy the Slurm charms on."
  type        = string
  default     = "ubuntu@26.04"
  nullable    = false
}

variable "channel" {
  description = "Channel to deploy the Slurm charms from."
  type        = string
  default     = "latest/edge"
  nullable    = false
}

variable "expose_endpoints" {
  description = <<-EOT
    Endpoints to expose as cross-model offers, identified by the
    `<charm_name>_<endpoint>` keys of the `provides` and `requires` outputs.
    Subordinate and container-scoped endpoints cannot be offered, and neither
    can applications deployed per partition (`slurmd`).
  EOT
  type        = list(string)
  default     = []
}

variable "model_uuid" {
  description = "UUID of the target Juju model."
  type        = string
  nullable    = false
}

variable "sackd" {
  description = "Configuration options for the Slurm client daemon (sackd)."
  type = object({
    app_name    = optional(string, "sackd"),
    base        = optional(string),
    channel     = optional(string),
    revision    = optional(number),
    units       = optional(number),
    config      = optional(map(string)),
    constraints = optional(string),
    machines    = optional(list(string), [])
  })
  nullable = false
  default  = {}
}

variable "slurmctld" {
  description = "Configuration options for the Slurm controller daemon (slurmctld)."
  type = object({
    app_name    = optional(string, "slurmctld"),
    base        = optional(string),
    channel     = optional(string),
    revision    = optional(number),
    units       = optional(number),
    config      = optional(map(string)),
    constraints = optional(string),
    machines    = optional(list(string), [])
  })
  nullable = false
  default  = {}
}

variable "slurmd_partitions" {
  description = "Map of Slurm partitions to deploy, keyed by partition name. Each entry deploys a slurmd application."
  type = map(
    object({
      base        = optional(string),
      channel     = optional(string),
      revision    = optional(number),
      units       = optional(number),
      config      = optional(map(string)),
      constraints = optional(string),
      machines    = optional(list(string), [])
    })
  )
  default = {
    "compute" : {
      units = 1
    }
  }
}

variable "slurmdbd" {
  description = "Configuration options for the Slurm database daemon (slurmdbd)."
  type = object({
    app_name    = optional(string, "slurmdbd"),
    base        = optional(string),
    channel     = optional(string),
    revision    = optional(number),
    units       = optional(number),
    config      = optional(map(string)),
    constraints = optional(string),
    machines    = optional(list(string), [])
  })
  nullable = false
  default  = {}
}

variable "slurmdbd_backend" {
  description = <<-EOT
    MySQL-compatible database backend for the Slurm accounting stack. Set
    `name` (and `endpoint` only when the application needs disambiguation) to
    use an in-model application, or `offer_url` to use a cross-model offer.
    Set `offering_controller` when the offer is hosted on a different
    controller.
  EOT
  type = object({
    name                = optional(string),
    endpoint            = optional(string),
    offer_url           = optional(string),
    offering_controller = optional(string),
  })
  nullable = false
}

variable "slurmrestd" {
  description = "Configuration options for the Slurm REST daemon (slurmrestd)."
  type = object({
    app_name    = optional(string, "slurmrestd"),
    base        = optional(string),
    channel     = optional(string),
    revision    = optional(number),
    units       = optional(number),
    config      = optional(map(string)),
    constraints = optional(string),
    machines    = optional(list(string), [])
  })
  nullable = false
  default  = {}
}
