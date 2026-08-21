# Deploy a Lustre share and mount it on an Ubuntu machine

This example deploys a two-unit [`lustre-server`](../../../modules/lustre) cluster (one MGS+MDS and one OSS) and a
`filesystem-client`, then integrates the client with a generic `ubuntu` application so the Lustre share is mounted at
`/lustre`.

## Usage

Ensure you have a Juju controller on LXD, then:

```shell
tofu init
tofu apply
```

To inspect the cluster:

```shell
juju status
juju exec --unit lustre-client/0 -- lfs df -h /lustre
```

To tear everything down:

```shell
tofu destroy
```
