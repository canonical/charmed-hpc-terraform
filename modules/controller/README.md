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

## Requirements

- Terraform >= 1.6.6
- Juju Terraform provider >= 1.0
- A cloud already known to the Juju CLI, with credentials available
  (`juju add-cloud` / `juju add-credentials`)

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
