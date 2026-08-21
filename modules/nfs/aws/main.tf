# Copyright 2025 Canonical Ltd.
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

data "aws_vpc" "this" {
  id = var.vpc_id
}

data "aws_subnet" "this" {
  id = var.subnet_id
}

module "efs" {
  source  = "terraform-aws-modules/efs/aws"
  version = "~> 1.6"

  name             = var.name
  performance_mode = "generalPurpose"
  throughput_mode  = "elastic"

  # Allows connecting using a plain old NFS client
  encrypted     = false
  attach_policy = false

  lifecycle_policy = {
    transition_to_ia = "AFTER_30_DAYS"
  }

  mount_targets = {
    efs-subnet = {
      subnet_id = data.aws_subnet.this.id
    }
  }

  security_group_description = "${var.name} security group"
  security_group_vpc_id      = data.aws_vpc.this.id
  security_group_rules = {
    ingress = {
      description = "${var.name} ingress for EFS"
      cidr_blocks = [data.aws_vpc.this.cidr_block]
    }
    egress = {
      description      = "${var.name} egress for EFS"
      type             = "egress"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  tags = {
    Terraform = "true"
  }
}

resource "juju_machine" "nfs-server-proxy" {
  model_uuid = var.model_uuid
  base       = var.base
  placement  = "subnet=${data.aws_subnet.this.cidr_block}"
}

module "nfs-server-proxy" {
  source = "git::https://github.com/canonical/filesystem-charms//charms/nfs-server-proxy/terraform?ref=0a49f1705d62e4fbb8c52360ad4b2372e8b64214"

  app_name   = "${var.name}-server"
  model_uuid = var.model_uuid
  base       = var.base
  channel    = var.nfs_server_proxy_channel
  machines   = [juju_machine.nfs-server-proxy.machine_id]
  units      = null
  config = {
    "hostname" : module.efs.dns_name
    "path" : "/"
  }
}

module "filesystem-client" {
  source = "git::https://github.com/canonical/filesystem-charms//charms/filesystem-client/terraform?ref=0a49f1705d62e4fbb8c52360ad4b2372e8b64214"

  app_name   = "${var.name}-client"
  model_uuid = var.model_uuid
  base       = var.base
  channel    = var.filesystem_client_channel
  config = {
    "mountpoint" : var.mountpoint
  }
}

resource "juju_integration" "nfs" {
  model_uuid = var.model_uuid

  application {
    name     = module.nfs-server-proxy.application.name
    endpoint = module.nfs-server-proxy.provides.filesystem
  }

  application {
    name     = module.filesystem-client.application.name
    endpoint = module.filesystem-client.requires.filesystem
  }
}
