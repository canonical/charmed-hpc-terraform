# Azure managed NFS server in Juju

This example shows how to create and deploy Azure resources including a virtual network,
security group, and subnet which has access to an NFS server, and how to deploy applications
using Juju. To enable deploying resources in Azure, read the [Usage section in modules/nfs/azure/README.md](../../../modules/nfs/azure/README.md#usage).

## Usage

To run this example, execute:

```bash
terragrunt init
terragrunt apply
```
