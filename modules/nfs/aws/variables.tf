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

variable "base" {
  description = "Base operating system to deploy the NFS charms on."
  type        = string
  default     = "ubuntu@26.04"
  nullable    = false
}

variable "filesystem_client" {
  description = "Configuration options for the filesystem-client."
  type = object({
    app_name = optional(string)
    base     = optional(string)
    channel  = optional(string, "latest/edge")
    revision = optional(number)
    config   = optional(map(string), {})
  })
  nullable = false
  default  = {}
}

variable "model_uuid" {
  description = "UUID of the target Juju model."
  type        = string
  nullable    = false
}

variable "mountpoint" {
  description = "Path to the directory where the NFS share will be mounted."
  type        = string
}

variable "name" {
  description = "Name for the exported NFS share and the prefix of all the related resources."
  type        = string
  default     = "nfs-share"
}

variable "nfs_server_proxy" {
  description = "Configuration options for the nfs-server-proxy."
  type = object({
    app_name    = optional(string)
    base        = optional(string)
    channel     = optional(string, "latest/edge")
    revision    = optional(number)
    config      = optional(map(string), {})
    constraints = optional(string)
  })
  nullable = false
  default  = {}
}

variable "subnet_id" {
  description = "Subnet ID where the NFS share will be allocated."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the resources created."
  type        = string
}
