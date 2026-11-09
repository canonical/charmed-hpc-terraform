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

locals {
  component_applications = merge(
    {
      sackd      = module.sackd.application
      slurmctld  = module.slurmctld.application
      slurmdbd   = module.slurmdbd.application
      slurmrestd = module.slurmrestd.application
    },
    { for name, partition in module.slurmd_partitions : name => partition.application }
  )

  offerable_endpoints = {
    sackd_metrics_endpoint = {
      application = module.sackd.application.name
      endpoint    = "metrics-endpoint"
    }
    slurmctld_influxdb = {
      application = module.slurmctld.application.name
      endpoint    = "influxdb"
    }
    slurmctld_smtp = {
      application = module.slurmctld.application.name
      endpoint    = "smtp"
    }
  }

  sackd = {
    app_name    = var.sackd.app_name
    base        = coalesce(var.sackd.base, var.base)
    channel     = coalesce(var.sackd.channel, var.channel)
    revision    = var.sackd.revision
    units       = length(var.sackd.machines) == 0 ? coalesce(var.sackd.units, 1) : null
    machines    = length(var.sackd.machines) == 0 ? null : var.sackd.machines
    config      = var.sackd.config
    constraints = var.sackd.constraints
  }

  slurmctld = {
    app_name    = var.slurmctld.app_name
    base        = coalesce(var.slurmctld.base, var.base)
    channel     = coalesce(var.slurmctld.channel, var.channel)
    revision    = var.slurmctld.revision
    units       = length(var.slurmctld.machines) == 0 ? coalesce(var.slurmctld.units, 1) : null
    machines    = length(var.slurmctld.machines) == 0 ? null : var.slurmctld.machines
    config      = var.slurmctld.config
    constraints = var.slurmctld.constraints
  }

  slurmd_partitions = {
    for name, partition in var.slurmd_partitions : name => {
      app_name    = name
      base        = coalesce(partition.base, var.base)
      channel     = coalesce(partition.channel, var.channel)
      revision    = partition.revision
      units       = length(partition.machines) == 0 ? coalesce(partition.units, 1) : null
      machines    = length(partition.machines) == 0 ? null : partition.machines
      config      = partition.config
      constraints = partition.constraints
    }
  }

  slurmdbd = {
    app_name    = var.slurmdbd.app_name
    base        = coalesce(var.slurmdbd.base, var.base)
    channel     = coalesce(var.slurmdbd.channel, var.channel)
    revision    = var.slurmdbd.revision
    units       = length(var.slurmdbd.machines) == 0 ? coalesce(var.slurmdbd.units, 1) : null
    machines    = length(var.slurmdbd.machines) == 0 ? null : var.slurmdbd.machines
    config      = var.slurmdbd.config
    constraints = var.slurmdbd.constraints
  }

  slurmrestd = {
    app_name    = var.slurmrestd.app_name
    base        = coalesce(var.slurmrestd.base, var.base)
    channel     = coalesce(var.slurmrestd.channel, var.channel)
    revision    = var.slurmrestd.revision
    units       = length(var.slurmrestd.machines) == 0 ? coalesce(var.slurmrestd.units, 1) : null
    machines    = length(var.slurmrestd.machines) == 0 ? null : var.slurmrestd.machines
    config      = var.slurmrestd.config
    constraints = var.slurmrestd.constraints
  }
}
