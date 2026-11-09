# Terraform module for Slurm Core

This is a Terraform module facilitating the deployment of the core components of a Slurm-based HPC cluster.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.6 |
| <a name="requirement_juju"></a> [juju](#requirement\_juju) | >= 1.0, < 3.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_juju"></a> [juju](#provider\_juju) | >= 1.0, < 3.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module_sackd"></a> [sackd](#module\_sackd) | git::https://github.com/canonical/slurm-charms//charms/sackd/terraform | 9943f751b39268c24167ccddf9dc7145ce69cdae |
| <a name="module_slurmctld"></a> [slurmctld](#module\_slurmctld) | git::https://github.com/canonical/slurm-charms//charms/slurmctld/terraform | 9943f751b39268c24167ccddf9dc7145ce69cdae |
| <a name="module_slurmd_partitions"></a> [slurmd\_partitions](#module\_slurmd\_partitions) | git::https://github.com/canonical/slurm-charms//charms/slurmd/terraform | 9943f751b39268c24167ccddf9dc7145ce69cdae |
| <a name="module_slurmdbd"></a> [slurmdbd](#module\_slurmdbd) | git::https://github.com/canonical/slurm-charms//charms/slurmdbd/terraform | 9943f751b39268c24167ccddf9dc7145ce69cdae |
| <a name="module_slurmrestd"></a> [slurmrestd](#module\_slurmrestd) | git::https://github.com/canonical/slurm-charms//charms/slurmrestd/terraform | 9943f751b39268c24167ccddf9dc7145ce69cdae |

## Resources

| Name | Type |
| ---- | ---- |
| [juju_integration.sackd-to-slurmctld](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.slurmd-to-slurmctld](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.slurmdbd-to-mysql](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.slurmdbd-to-slurmctld](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.slurmrestd-to-slurmctld](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_offer.offered](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/offer) | resource |
| [terraform_data.single_unit_services](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_base"></a> [base](#input\_base) | Base operating system to deploy the Slurm charms on. | `string` | `"ubuntu@26.04"` | no |
| <a name="input_channel"></a> [channel](#input\_channel) | Channel to deploy the Slurm charms from. | `string` | `"latest/edge"` | no |
| <a name="input_expose_endpoints"></a> [expose\_endpoints](#input\_expose\_endpoints) | Endpoints to expose as cross-model offers, identified by the<br/>`<charm_name>_<endpoint>` keys of the `provides` and `requires` outputs.<br/>Subordinate and container-scoped endpoints cannot be offered, and neither<br/>can applications deployed per partition (`slurmd`). | `list(string)` | `[]` | no |
| <a name="input_model_uuid"></a> [model\_uuid](#input\_model\_uuid) | UUID of the target Juju model. | `string` | n/a | yes |
| <a name="input_sackd"></a> [sackd](#input\_sackd) | Configuration options for the Slurm client daemon (sackd). | <pre>object({<br/>    app_name    = optional(string, "sackd"),<br/>    base        = optional(string),<br/>    channel     = optional(string),<br/>    revision    = optional(number),<br/>    units       = optional(number),<br/>    config      = optional(map(string)),<br/>    constraints = optional(string),<br/>    machines    = optional(list(string), [])<br/>  })</pre> | `{}` | no |
| <a name="input_slurmctld"></a> [slurmctld](#input\_slurmctld) | Configuration options for the Slurm controller daemon (slurmctld). | <pre>object({<br/>    app_name    = optional(string, "slurmctld"),<br/>    base        = optional(string),<br/>    channel     = optional(string),<br/>    revision    = optional(number),<br/>    units       = optional(number),<br/>    config      = optional(map(string)),<br/>    constraints = optional(string),<br/>    machines    = optional(list(string), [])<br/>  })</pre> | `{}` | no |
| <a name="input_slurmd_partitions"></a> [slurmd\_partitions](#input\_slurmd\_partitions) | Map of Slurm partitions to deploy, keyed by partition name. Each entry deploys a slurmd application. | <pre>map(<br/>    object({<br/>      base        = optional(string),<br/>      channel     = optional(string),<br/>      revision    = optional(number),<br/>      units       = optional(number),<br/>      config      = optional(map(string)),<br/>      constraints = optional(string),<br/>      machines    = optional(list(string), [])<br/>    })<br/>  )</pre> | <pre>{<br/>  "compute": {<br/>    "units": 1<br/>  }<br/>}</pre> | no |
| <a name="input_slurmdbd"></a> [slurmdbd](#input\_slurmdbd) | Configuration options for the Slurm database daemon (slurmdbd). | <pre>object({<br/>    app_name    = optional(string, "slurmdbd"),<br/>    base        = optional(string),<br/>    channel     = optional(string),<br/>    revision    = optional(number),<br/>    units       = optional(number),<br/>    config      = optional(map(string)),<br/>    constraints = optional(string),<br/>    machines    = optional(list(string), [])<br/>  })</pre> | `{}` | no |
| <a name="input_slurmdbd_backend"></a> [slurmdbd\_backend](#input\_slurmdbd\_backend) | MySQL-compatible database backend for the Slurm accounting stack. Set<br/>`name` (and `endpoint` only when the application needs disambiguation) to<br/>use an in-model application, or `offer_url` to use a cross-model offer.<br/>Set `offering_controller` when the offer is hosted on a different<br/>controller. | <pre>object({<br/>    name                = optional(string),<br/>    endpoint            = optional(string),<br/>    offer_url           = optional(string),<br/>    offering_controller = optional(string),<br/>  })</pre> | n/a | yes |
| <a name="input_slurmrestd"></a> [slurmrestd](#input\_slurmrestd) | Configuration options for the Slurm REST daemon (slurmrestd). | <pre>object({<br/>    app_name    = optional(string, "slurmrestd"),<br/>    base        = optional(string),<br/>    channel     = optional(string),<br/>    revision    = optional(number),<br/>    units       = optional(number),<br/>    config      = optional(map(string)),<br/>    constraints = optional(string),<br/>    machines    = optional(list(string), [])<br/>  })</pre> | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_components"></a> [components](#output\_components) | Map of deployed applications, keyed by component name. Partition applications are keyed by partition name. |
| <a name="output_offers"></a> [offers](#output\_offers) | Map of exposed cross-model offers, keyed by `<charm_name>_<endpoint>`. |
| <a name="output_provides"></a> [provides](#output\_provides) | Map of provides endpoints available for external integration, keyed by `<charm_name>_<endpoint>`. |
| <a name="output_requires"></a> [requires](#output\_requires) | Map of requires endpoints available for external integration, keyed by `<charm_name>_<endpoint>`. |
<!-- END_TF_DOCS -->

## Component configuration

Each deployment option object (`sackd`, `slurmctld`, `slurmdbd`, `slurmrestd`) and
each entry of `slurmd_partitions` accepts the following keys:

| Name          | Type         | Description                                                                                     |
|---------------|--------------|-------------------------------------------------------------------------------------------------|
| `app_name`    | string       | Name of the deployed Juju application                                                           |
| `base`        | string       | Base operating system for this component. Defaults to the module-level `base`                   |
| `channel`     | string       | Charm channel for this component. Defaults to the module-level `channel`                        |
| `config`      | map(string)  | Charm configuration options                                                                     |
| `constraints` | string       | Juju constraints to apply to the deployment                                                     |
| `machines`    | list(string) | Machines to place the application on. If set, `units` is ignored.                               |
| `revision`    | number       | Charm revision to deploy. Null deploys the latest revision on the given channel                 |
| `units`       | number       | Number of units to deploy when no `machines` are provided (defaults to 1)                       |

The `slurmdbd_backend` object configures the MySQL-compatible database backing
the Slurm accounting stack. It accepts the following keys:

| Name                  | Type   | Description                                                                    |
|-----------------------|--------|--------------------------------------------------------------------------------|
| `endpoint`            | string | Endpoint of the in-model application. Only needed to disambiguate the relation |
| `name`                | string | Name of the in-model database application                                      |
| `offer_url`           | string | URL of a cross-model offer exposing the `mysql_client` interface               |
| `offering_controller` | string | Name of the controller hosting the offer, when it differs from the target one  |

Set either `name` (in-model backend) or `offer_url` (cross-model backend).

## Endpoint availability

The `provides` and `requires` outputs expose only the endpoints available for
external integration. Endpoints that the module wires itself (e.g. the
relations between the Slurm daemons) are omitted; use the `components` output
for the application names to relate against.

The `provides` output exposes the following endpoints:

| Key                      | Endpoint name      |
|--------------------------|--------------------|
| `sackd_metrics_endpoint` | `metrics-endpoint` |
| `slurmctld_cos_agent`    | `cos-agent`        |
| `slurmctld_mount`        | `mount`            |

The `requires` output exposes the following endpoints:

| Key                     | Endpoint name |
|-------------------------|---------------|
| `slurmctld_influxdb`    | `influxdb`    |
| `slurmctld_oci_runtime` | `oci-runtime` |
| `slurmctld_smtp`        | `smtp`        |

Set `expose_endpoints` to expose endpoints as cross-model offers, using the
keys of the `provides` and `requires` outputs as identifiers. The `offers`
output provides the resulting offer URLs for other models to consume. Endpoints
whose only implementors are subordinate or container-scoped charms
(`slurmctld_cos_agent`, `slurmctld_oci_runtime`, and `slurmctld_mount`) cannot
be related across models and are not offerable.

## Usage

See the [`slurm`](../../examples/slurm/main.tf) example for an usage example.
