# Deploy a Lustre share on Azure with InfiniBand

This example deploys a [`lustre-server`](../../../modules/lustre) cluster on Azure using RDMA-capable VMs, a
`filesystem-client`, and integrates the client with a generic `ubuntu` application so the Lustre share is mounted at
`/lustre`.

## Prerequisites

* Azure credentials configured for both the `azurerm` provider and the Juju Azure cloud (a service principal with
  permission to create the network resources and to provision machines). Set the usual `ARM_*` environment variables
  and register the credential with Juju (`juju add-credential azure`).
* A region and VM size that support InfiniBand. The default is `Standard_HB120rs_v3` in `eastus`; adjust
  `server_vm_size` and `location` for your quota. InfiniBand sizes (HB, HC, ND families) require a quota increase in
  most subscriptions.

## Usage

```shell
tofu init
tofu apply
```

To tear everything down:

```shell
tofu destroy
```
