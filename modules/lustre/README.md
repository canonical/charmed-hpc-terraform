# Terraform module for Lustre

This is a Terraform module facilitating the deployment of a [Lustre](https://www.lustre.org/) parallel file system using
the `lustre-server` charm, and the corresponding `filesystem-client` charm to mount the filesystem on Juju machines.

The `lustre-server` charm provisions all Lustre server components (MGS, MDS, and OSS) with ZFS-backed storage pools.
The first unit acts as the MGS+MDS; additional units act as OSSes. A minimum of two units is required for a usable
filesystem.

## Machine requirements

* Lustre requires kernel modules (built via DKMS) and ZFS, so the server units must run on **virtual machines**, not
  LXD containers.
* On the LXD cloud, the LXD profile Juju generates for the model must have Secure Boot disabled
  (`boot.mode=uefi-nosecureboot`) so the unsigned DKMS modules can be loaded. See the
  [example](../../examples/lustre/main.tf) for how to apply this automatically.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0 |
| <a name="requirement_juju"></a> [juju](#requirement\_juju) | >= 1.0, < 3.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_juju"></a> [juju](#provider\_juju) | >= 1.0, < 3.0 |

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module_filesystem-client"></a> [filesystem-client](#module\_filesystem-client) | git::https://github.com/canonical/filesystem-charms//charms/filesystem-client/terraform | 0a49f1705d62e4fbb8c52360ad4b2372e8b64214 |
| <a name="module_lustre-server"></a> [lustre-server](#module\_lustre-server) | git::https://github.com/canonical/filesystem-charms//charms/lustre-server/terraform | 0a49f1705d62e4fbb8c52360ad4b2372e8b64214 |

## Resources

| Name | Type |
| ---- | ---- |
| [juju_integration.lustre](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_offer.offered](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/offer) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_base"></a> [base](#input\_base) | Base operating system to deploy the Lustre charms on. | `string` | `"ubuntu@26.04"` | no |
| <a name="input_client"></a> [client](#input\_client) | Configuration options for the filesystem client that mounts the Lustre share. | <pre>object({<br/>    app_name   = optional(string, "lustre-client")<br/>    base       = optional(string)<br/>    channel    = optional(string, "latest/edge")<br/>    config     = optional(map(string), {})<br/>    mountpoint = string<br/>    revision   = optional(number)<br/>  })</pre> | n/a | yes |
| <a name="input_model_uuid"></a> [model\_uuid](#input\_model\_uuid) | UUID of the target Juju model. | `string` | n/a | yes |
| <a name="input_offered_endpoints"></a> [offered\_endpoints](#input\_offered\_endpoints) | Endpoints to expose as cross-model offers, identified by the<br/>`<charm_name>_<endpoint>` keys of the `provides` and `requires` outputs. | `list(string)` | `[]` | no |
| <a name="input_server"></a> [server](#input\_server) | Configuration options for the Lustre server. | <pre>object({<br/>    app_name    = optional(string, "lustre-server")<br/>    base        = optional(string)<br/>    channel     = optional(string, "latest/edge")<br/>    config      = optional(map(string), {})<br/>    constraints = optional(string, "")<br/>    machines    = optional(list(string), [])<br/>    revision    = optional(number)<br/>    units       = optional(number, 1)<br/>  })</pre> | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_app_name"></a> [app\_name](#output\_app\_name) | The name of the filesystem client application. |
| <a name="output_components"></a> [components](#output\_components) | Map of deployed applications, keyed by component name. |
| <a name="output_mountpoint"></a> [mountpoint](#output\_mountpoint) | Path where the Lustre filesystem is mounted on client machines. |
| <a name="output_offers"></a> [offers](#output\_offers) | Map of exposed cross-model offers, keyed by `<charm_name>_<endpoint>`. |
| <a name="output_provides"></a> [provides](#output\_provides) | Map of provides endpoints available for external integration, keyed by `<charm_name>_<endpoint>`. |
| <a name="output_requires"></a> [requires](#output\_requires) | Map of requires endpoints available for external integration, keyed by `<charm_name>_<endpoint>`. |
<!-- END_TF_DOCS -->

## Component configuration

The `server` object accepts the following properties:

| Name          | Type        | Description                                                                     | Default         | Required |
|---------------|-------------|---------------------------------------------------------------------------------|-----------------|:--------:|
| `app_name`    | string      | Name of the server application                                                  | "lustre-server" |          |
| `base`        | string      | Base operating system for the server. Defaults to the module-level `base`       |                 |          |
| `channel`     | string      | Charm channel to deploy the server from                                         | "latest/edge"   |          |
| `config`      | map(string) | Juju configuration options for the server                                       | `{}`            |          |
| `constraints` | string      | Juju constraints for the server                                                 | ""              |          |
| `machines`    | array       | Machines where the server nodes are deployed. If set, `units` is ignored        | `[]`            |          |
| `revision`    | number      | Charm revision to deploy. Null deploys the latest revision on the given channel |                 |          |
| `units`       | number      | Number of Lustre server units                                                   | 1               |          |

If the `machines` property is set, the `units` variable is ignored.

The `client` object accepts the following properties:

| Name         | Type        | Description                                                                     | Default         | Required |
|--------------|-------------|---------------------------------------------------------------------------------|-----------------|:--------:|
| `app_name`   | string      | Name of the client application                                                  | "lustre-client" |          |
| `base`       | string      | Base operating system for the client. Defaults to the module-level `base`       |                 |          |
| `channel`    | string      | Charm channel to deploy the client from                                         | "latest/edge"   |          |
| `config`     | map(string) | Juju configuration options for the client                                       | `{}`            |          |
| `mountpoint` | string      | Path where the filesystem will be mounted                                       |                 |    Y     |
| `revision`   | number      | Charm revision to deploy. Null deploys the latest revision on the given channel |                 |          |

## Endpoint availability

The `provides` and `requires` outputs expose only the endpoints available for
external integration. Endpoints that the module wires itself (the relation
between the Lustre server and the filesystem client) are omitted; use the
`components` output for the application names to relate against.

The `provides` output exposes the following endpoints:

| Key                        | Endpoint name |
|----------------------------|---------------|
| `lustre_server_filesystem` | `filesystem`  |

The `requires` output exposes the following endpoints:

| Key                            | Endpoint name |
|--------------------------------|---------------|
| `filesystem_client_juju_info`  | `juju-info`   |
| `filesystem_client_mount`      | `mount`       |

Set `offered_endpoints` to expose endpoints as cross-model offers, using the
keys of the `provides` and `requires` outputs as identifiers. The `offers`
output provides the resulting offer URLs for other models to consume. Only
`lustre_server_filesystem` can be offered: subordinate and container-scoped
endpoints (`juju-info`, `mount`) cannot be related across models.

## Usage

See the [`lustre`](../../examples/lustre/main.tf) example for an usage example.
