# Azure Files-backed NFS share integrated with a set of Juju applications.
#
# Deploys the nfs/azure module (storage account, share, private endpoint, and
# the nfs-server-proxy + filesystem-client charms) and integrates the
# filesystem client with each application in `applications` via the
# `juju-info` endpoint (the filesystem client is a subordinate charm).

module "nfs-share" {
  source = "../../../../../modules/nfs/azure"

  name                = var.name
  resource_group_name = var.resource_group_name
  subnet_info         = var.subnet_info
  model_uuid          = var.model_uuid
  quota               = var.quota
  mountpoint          = var.mountpoint
}

resource "juju_integration" "nfs" {
  for_each   = toset(var.applications)
  model_uuid = var.model_uuid

  application {
    name     = each.value
    endpoint = "juju-info"
  }

  application {
    name     = module.nfs-share.app_name
    endpoint = "juju-info"
  }
}
