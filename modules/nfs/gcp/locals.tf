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

locals {
  filesystem_client = {
    app_name = coalesce(var.filesystem_client.app_name, "${var.name}-client")
    base     = coalesce(var.filesystem_client.base, var.base)
    channel  = var.filesystem_client.channel
    revision = var.filesystem_client.revision
    config   = merge({ mountpoint = var.mountpoint }, var.filesystem_client.config)
  }

  nfs_server_proxy = {
    app_name    = coalesce(var.nfs_server_proxy.app_name, "${var.name}-server")
    base        = coalesce(var.nfs_server_proxy.base, var.base)
    channel     = var.nfs_server_proxy.channel
    revision    = var.nfs_server_proxy.revision
    constraints = var.nfs_server_proxy.constraints
    config = merge({
      "hostname" : google_filestore_instance.nfs.networks[0].ip_addresses[0]
      "path" : "/${local.share_name}"
    }, var.nfs_server_proxy.config)
    machines = null
    units    = null
  }

  share_name = replace(substr(var.name, 0, 10), "-", "_")
}
