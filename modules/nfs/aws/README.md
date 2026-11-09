# Terraform module for AWS managed NFS

This is a Terraform module facilitating the deployment of an NFS share managed by Amazon Web Services (AWS), and the
corresponding proxy and client charms to mount the filesystem on Juju machines.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~>5.99 |
| <a name="requirement_juju"></a> [juju](#requirement\_juju) | >= 1.0, < 3.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~>5.99 |
| <a name="provider_juju"></a> [juju](#provider\_juju) | >= 1.0, < 3.0 |

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module_efs"></a> [efs](#module\_efs) | terraform-aws-modules/efs/aws | ~> 1.6 |
| <a name="module_filesystem-client"></a> [filesystem-client](#module\_filesystem-client) | git::https://github.com/canonical/filesystem-charms//charms/filesystem-client/terraform | 0a49f1705d62e4fbb8c52360ad4b2372e8b64214 |
| <a name="module_nfs-server-proxy"></a> [nfs-server-proxy](#module\_nfs-server-proxy) | git::https://github.com/canonical/filesystem-charms//charms/nfs-server-proxy/terraform | 0a49f1705d62e4fbb8c52360ad4b2372e8b64214 |

## Resources

| Name | Type |
| ---- | ---- |
| [juju_integration.nfs](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_machine.nfs-server-proxy](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/machine) | resource |
| [aws_subnet.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_base"></a> [base](#input\_base) | Base operating system to deploy the NFS charms on. | `string` | `"ubuntu@26.04"` | no |
| <a name="input_filesystem_client"></a> [filesystem\_client](#input\_filesystem\_client) | Configuration options for the filesystem-client. | <pre>object({<br/>    app_name = optional(string)<br/>    base     = optional(string)<br/>    channel  = optional(string, "latest/edge")<br/>    revision = optional(number)<br/>    config   = optional(map(string), {})<br/>  })</pre> | `{}` | no |
| <a name="input_model_uuid"></a> [model\_uuid](#input\_model\_uuid) | UUID of the target Juju model. | `string` | n/a | yes |
| <a name="input_mountpoint"></a> [mountpoint](#input\_mountpoint) | Path to the directory where the NFS share will be mounted. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name for the exported NFS share and the prefix of all the related resources. | `string` | `"nfs-share"` | no |
| <a name="input_nfs_server_proxy"></a> [nfs\_server\_proxy](#input\_nfs\_server\_proxy) | Configuration options for the nfs-server-proxy. | <pre>object({<br/>    app_name    = optional(string)<br/>    base        = optional(string)<br/>    channel     = optional(string, "latest/edge")<br/>    revision    = optional(number)<br/>    config      = optional(map(string), {})<br/>    constraints = optional(string)<br/>  })</pre> | `{}` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | Subnet ID where the NFS share will be allocated. | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID for the resources created. | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_app_name"></a> [app\_name](#output\_app\_name) | The name of the filesystem client application. |
| <a name="output_components"></a> [components](#output\_components) | Map of deployed applications, keyed by component name. |
<!-- END_TF_DOCS -->

## Usage

This module requires authenticating against AWS before configuring the provider instance. This can be done by setting
the following environment variables:

```shell
# Bash etc.
export AWS_ACCESS_KEY_ID=XXXXXXXXXXXXXXXXXXX
export AWS_SECRET_ACCESS_KEY=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
export AWS_REGION="us-east-1"
```
