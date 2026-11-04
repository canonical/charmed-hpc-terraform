# Terraform module for Juju controller bootstrap

This is a Terraform module facilitating the bootstrap of a
[Juju](https://juju.is) controller on a cloud, using the
[Juju Terraform provider](https://github.com/juju/terraform-provider-juju).
For more information, refer to the
[documentation](https://registry.terraform.io/providers/juju/juju/latest/docs)
for the Juju Terraform provider.

> [!NOTE]
> This module bootstraps a controller and therefore does not follow the
> charm-module interface: no Juju model exists before the bootstrap completes,
> so charm-module inputs such as `model_uuid` are not applicable.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.6 |
| <a name="requirement_juju"></a> [juju](#requirement\_juju) | >= 1.3, < 3.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | ~> 2.5 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_juju"></a> [juju](#provider\_juju) | >= 1.3, < 3.0 |
| <a name="provider_local"></a> [local](#provider\_local) | ~> 2.5 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [juju_controller.this](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/controller) | resource |
| [local_sensitive_file.juju-accounts-yaml](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/sensitive_file) | resource |
| [local_sensitive_file.juju-controllers-yaml](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/sensitive_file) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_agent_version"></a> [agent\_version](#input\_agent\_version) | Controller agent version to bootstrap. If null, the latest stable version is used. | `string` | `null` | no |
| <a name="input_bootstrap_base"></a> [bootstrap\_base](#input\_bootstrap\_base) | Base operating system for the bootstrap machine. | `string` | `"ubuntu@24.04"` | no |
| <a name="input_bootstrap_constraints"></a> [bootstrap\_constraints](#input\_bootstrap\_constraints) | Constraints for the bootstrap machine. | `map(string)` | `{}` | no |
| <a name="input_cloud"></a> [cloud](#input\_cloud) | Definition of the cloud where the controller will operate. `name`, `type`,<br/>and `auth_types` are required. `endpoint` is required for non-public clouds<br/>(for example, a private LXD or OpenStack endpoint). `region` selects the<br/>cloud region the controller operates in. `ca_certificates` are required<br/>when the cloud endpoint uses self-signed certificates. | <pre>object({<br/>    name            = string<br/>    type            = string<br/>    auth_types      = list(string)<br/>    endpoint        = optional(string)<br/>    region          = optional(object({ name = string, endpoint = optional(string), identity_endpoint = optional(string), storage_endpoint = optional(string) }))<br/>    ca_certificates = optional(list(string), [])<br/>  })</pre> | n/a | yes |
| <a name="input_cloud_credential"></a> [cloud\_credential](#input\_cloud\_credential) | Cloud credentials used to bootstrap the controller. | <pre>object({<br/>    name       = string<br/>    auth_type  = string<br/>    attributes = map(string)<br/>  })</pre> | n/a | yes |
| <a name="input_controller_config"></a> [controller\_config](#input\_controller\_config) | Configuration options for the bootstrapped controller. | `map(string)` | `{}` | no |
| <a name="input_controller_name"></a> [controller\_name](#input\_controller\_name) | Name to assign to the controller. | `string` | n/a | yes |
| <a name="input_juju_binary"></a> [juju\_binary](#input\_juju\_binary) | Path to the Juju CLI binary. Use /snap/juju/current/bin/juju when Juju is installed as a snap. | `string` | `"/snap/juju/current/bin/juju"` | no |
| <a name="input_juju_data_dir"></a> [juju\_data\_dir](#input\_juju\_data\_dir) | Directory where the Juju data files (controllers.yaml and accounts.yaml) are<br/>  written. Setting this variable opts in to writing them: point the JUJU\_DATA<br/>  environment variable at the directory to use the Juju CLI with the<br/>  controller. If null, no Juju data files are written and only the connection<br/>  outputs are available. Existing files with the same names are overwritten.<br/>existing files with the same names are overwritten. | `string` | `null` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_api_addresses"></a> [api\_addresses](#output\_api\_addresses) | API addresses of the controller. |
| <a name="output_ca_cert"></a> [ca\_cert](#output\_ca\_cert) | CA certificate for the controller. |
| <a name="output_connection"></a> [connection](#output\_connection) | Connection details for the controller, suitable for configuring a Juju provider in a separate plan. |
| <a name="output_controller_uuid"></a> [controller\_uuid](#output\_controller\_uuid) | UUID of the bootstrapped controller. |
| <a name="output_juju_data_dir"></a> [juju\_data\_dir](#output\_juju\_data\_dir) | Path to the Juju data directory with the controller registered and the admin user already logged in. |
| <a name="output_password"></a> [password](#output\_password) | Admin password for the controller. |
| <a name="output_username"></a> [username](#output\_username) | Admin username for the controller. |
<!-- END_TF_DOCS -->

## Usage

```terraform
module "controller" {
  source = "./modules/controller"

  name    = "my-controller"
  cloud = {
    name       = "localhost"
    type       = "lxd"
    auth_types = ["empty"]
  }
  cloud_credential = {
    name       = "localhost"
    auth_type  = "empty"
    attributes = {}
  }
}
```

The `connection` output carries the controller addresses, username, password
and CA certificate, suitable for configuring the Juju provider of a follow-up
plan. If `juju_data_dir` is set, the module also writes `controllers.yaml` and
`accounts.yaml` into that directory for temporary Juju CLI access.
