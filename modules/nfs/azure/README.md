# Terraform module for Azure managed NFS

This is a Terraform module facilitating the deployment of an NFS share managed by Azure, and the
corresponding proxy and client charms to mount the filesystem on Juju machines.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.6 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>4.17 |
| <a name="requirement_juju"></a> [juju](#requirement\_juju) | >= 1.0, < 3.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~>4.17 |
| <a name="provider_juju"></a> [juju](#provider\_juju) | >= 1.0, < 3.0 |
| <a name="provider_random"></a> [random](#provider\_random) | ~> 3.0 |

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module_filesystem-client"></a> [filesystem-client](#module\_filesystem-client) | git::https://github.com/canonical/filesystem-charms//charms/filesystem-client/terraform | 0a49f1705d62e4fbb8c52360ad4b2372e8b64214 |
| <a name="module_nfs-server-proxy"></a> [nfs-server-proxy](#module\_nfs-server-proxy) | git::https://github.com/canonical/filesystem-charms//charms/nfs-server-proxy/terraform | 0a49f1705d62e4fbb8c52360ad4b2372e8b64214 |

## Resources

| Name | Type |
| ---- | ---- |
| [azurerm_private_dns_zone.nfs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.nfs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_endpoint.nfs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_storage_account.nfs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_share.nfs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_share) | resource |
| [juju_integration.nfs](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [random_id.nfs](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [azurerm_resource_group.nfs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subnet.nfs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_virtual_network.nfs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_base"></a> [base](#input\_base) | Base operating system to deploy the NFS charms on. | `string` | `"ubuntu@26.04"` | no |
| <a name="input_filesystem_client_channel"></a> [filesystem\_client\_channel](#input\_filesystem\_client\_channel) | Channel to deploy the filesystem-client charm from. | `string` | `"latest/edge"` | no |
| <a name="input_model_uuid"></a> [model\_uuid](#input\_model\_uuid) | UUID of the target Juju model. | `string` | n/a | yes |
| <a name="input_mountpoint"></a> [mountpoint](#input\_mountpoint) | Path to the directory where the NFS share will be mounted. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name for the exported NFS share and the prefix of all the related resources. | `string` | `"nfs-share"` | no |
| <a name="input_nfs_server_proxy_channel"></a> [nfs\_server\_proxy\_channel](#input\_nfs\_server\_proxy\_channel) | Channel to deploy the nfs-server-proxy charm from. | `string` | `"latest/edge"` | no |
| <a name="input_quota"></a> [quota](#input\_quota) | The maximum size of the share, in gigabytes. | `number` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the Azure resource group where the NFS share will be allocated. | `string` | n/a | yes |
| <a name="input_subnet_info"></a> [subnet\_info](#input\_subnet\_info) | Information about the subnet where the NFS share will be allocated. | `object({ name = string, virtual_network_name = string })` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_app_name"></a> [app\_name](#output\_app\_name) | The name of the filesystem client application. |
| <a name="output_components"></a> [components](#output\_components) | Map of deployed applications, keyed by component name. |
<!-- END_TF_DOCS -->

## Usage

Since this module uses version 4.0 of the Azure Provider, it requires specifying the Azure Subscription ID
before configuring the provider instance. This can be done by setting the `ARM_SUBSCRIPTION_ID` environment
variable:

```shell
# Bash etc.
export ARM_SUBSCRIPTION_ID=00000000-xxxx-xxxx-xxxx-xxxxxxxxxxxx
```
