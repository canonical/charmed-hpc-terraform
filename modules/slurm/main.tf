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

# slurmdbd and slurmrestd do not support HA setups
resource "terraform_data" "single_unit_services" {
  lifecycle {
    precondition {
      condition     = coalesce(var.slurmdbd.units, 1) <= 1 && length(var.slurmdbd.machines) <= 1
      error_message = "The Slurm database charm (slurmdbd) does not support HA setups and must be deployed with at most one unit or machine."
    }

    precondition {
      condition     = coalesce(var.slurmrestd.units, 1) <= 1 && length(var.slurmrestd.machines) <= 1
      error_message = "The Slurm REST API charm (slurmrestd) does not support HA setups and must be deployed with at most one unit or machine."
    }
  }
}

module "slurmctld" {
  source = "git::https://github.com/canonical/slurm-charms//charms/slurmctld/terraform?ref=9943f751b39268c24167ccddf9dc7145ce69cdae"

  model_uuid = var.model_uuid
  app_name   = local.slurmctld.app_name
  base       = local.slurmctld.base

  channel     = local.slurmctld.channel
  revision    = local.slurmctld.revision
  machines    = local.slurmctld.machines
  units       = local.slurmctld.units
  config      = local.slurmctld.config
  constraints = local.slurmctld.constraints
}

module "slurmdbd" {
  source = "git::https://github.com/canonical/slurm-charms//charms/slurmdbd/terraform?ref=9943f751b39268c24167ccddf9dc7145ce69cdae"

  model_uuid = var.model_uuid
  app_name   = local.slurmdbd.app_name
  base       = local.slurmdbd.base

  channel     = local.slurmdbd.channel
  revision    = local.slurmdbd.revision
  machines    = local.slurmdbd.machines
  units       = local.slurmdbd.units
  config      = local.slurmdbd.config
  constraints = local.slurmdbd.constraints
}

module "slurmrestd" {
  source = "git::https://github.com/canonical/slurm-charms//charms/slurmrestd/terraform?ref=9943f751b39268c24167ccddf9dc7145ce69cdae"

  model_uuid = var.model_uuid
  app_name   = local.slurmrestd.app_name
  base       = local.slurmrestd.base

  channel     = local.slurmrestd.channel
  revision    = local.slurmrestd.revision
  machines    = local.slurmrestd.machines
  units       = local.slurmrestd.units
  config      = local.slurmrestd.config
  constraints = local.slurmrestd.constraints
}

module "sackd" {
  source = "git::https://github.com/canonical/slurm-charms//charms/sackd/terraform?ref=9943f751b39268c24167ccddf9dc7145ce69cdae"

  model_uuid = var.model_uuid
  app_name   = local.sackd.app_name
  base       = local.sackd.base

  channel     = local.sackd.channel
  revision    = local.sackd.revision
  machines    = local.sackd.machines
  units       = local.sackd.units
  config      = local.sackd.config
  constraints = local.sackd.constraints
}

# Setup compute plane

module "slurmd_partitions" {
  for_each = var.slurmd_partitions
  source   = "git::https://github.com/canonical/slurm-charms//charms/slurmd/terraform?ref=9943f751b39268c24167ccddf9dc7145ce69cdae"

  model_uuid = var.model_uuid
  app_name   = local.slurmd_partitions[each.key].app_name
  base       = local.slurmd_partitions[each.key].base

  channel     = local.slurmd_partitions[each.key].channel
  revision    = local.slurmd_partitions[each.key].revision
  machines    = local.slurmd_partitions[each.key].machines
  units       = local.slurmd_partitions[each.key].units
  config      = local.slurmd_partitions[each.key].config
  constraints = local.slurmd_partitions[each.key].constraints
}
