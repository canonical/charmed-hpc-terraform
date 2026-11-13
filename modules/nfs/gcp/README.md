# Terraform module for GCP managed NFS

This is a Terraform module facilitating the deployment of an NFS share managed by Google Cloud Platform (GCP), and the
corresponding proxy and client charms to mount the filesystem on Juju machines.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.6 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~>6.41 |
| <a name="requirement_juju"></a> [juju](#requirement\_juju) | >= 1.0, < 3.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_google"></a> [google](#provider\_google) | ~>6.41 |
| <a name="provider_juju"></a> [juju](#provider\_juju) | >= 1.0, < 3.0 |

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module_filesystem-client"></a> [filesystem-client](#module\_filesystem-client) | git::https://github.com/canonical/filesystem-charms//charms/filesystem-client/terraform | 0a49f1705d62e4fbb8c52360ad4b2372e8b64214 |
| <a name="module_nfs-server-proxy"></a> [nfs-server-proxy](#module\_nfs-server-proxy) | git::https://github.com/canonical/filesystem-charms//charms/nfs-server-proxy/terraform | 0a49f1705d62e4fbb8c52360ad4b2372e8b64214 |

## Resources

| Name | Type |
| ---- | ---- |
| [google_filestore_instance.nfs](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/filestore_instance) | resource |
| [juju_integration.nfs](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_base"></a> [base](#input\_base) | Base operating system to deploy the NFS charms on. | `string` | `"ubuntu@26.04"` | no |
| <a name="input_capacity_gb"></a> [capacity\_gb](#input\_capacity\_gb) | File share capacity in GiB.<br/>This must be at least 1024 GiB for the standard tier, or 2560 GiB for the premium tier. | `number` | n/a | yes |
| <a name="input_filesystem_client_channel"></a> [filesystem\_client\_channel](#input\_filesystem\_client\_channel) | Channel to deploy the filesystem-client charm from. | `string` | `"latest/edge"` | no |
| <a name="input_location"></a> [location](#input\_location) | The name of the location of the instance. This can be a region for ENTERPRISE tier instances. | `string` | `null` | no |
| <a name="input_model_uuid"></a> [model\_uuid](#input\_model\_uuid) | UUID of the target Juju model. | `string` | n/a | yes |
| <a name="input_mountpoint"></a> [mountpoint](#input\_mountpoint) | Path to the directory where the NFS share will be mounted. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name for the exported NFS share and the prefix of all the related resources. | `string` | `"nfs-share"` | no |
| <a name="input_network"></a> [network](#input\_network) | Name of the VPC Network where the NFS instance will be emplaced. | `string` | n/a | yes |
| <a name="input_nfs_server_proxy_channel"></a> [nfs\_server\_proxy\_channel](#input\_nfs\_server\_proxy\_channel) | Channel to deploy the nfs-server-proxy charm from. | `string` | `"latest/edge"` | no |
| <a name="input_tier"></a> [tier](#input\_tier) | The service tier of the instance.<br/>Possible values include: STANDARD, PREMIUM, BASIC\_HDD, BASIC\_SSD, HIGH\_SCALE\_SSD, ZONAL, REGIONAL and ENTERPRISE | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_app_name"></a> [app\_name](#output\_app\_name) | The name of the filesystem client application. |
| <a name="output_components"></a> [components](#output\_components) | Map of deployed applications, keyed by component name. |
<!-- END_TF_DOCS -->

## Usage

This module requires authenticating against GCP before configuring the provider instance, and setting up the
default GCP project, region and zone. You can create a new set of credentials for the Terraform
provider by following:

- [Create service accounts](https://cloud.google.com/iam/docs/service-accounts-create#gcloud)
  to create a new service account.
- [Grant or revoke a single IAM role](https://cloud.google.com/iam/docs/granting-changing-revoking-access#single-role)
  to grant the correct roles to the service account.
  This module only requires the `roles/file.editor` role, but if you are planning to share
  the same service account with Juju, it will additionally require the `roles/compute.instanceAdmin.v1`
  and `roles/compute.securityAdmin` roles.
- [Create a service account key](https://cloud.google.com/iam/docs/keys-create-delete#creating)
  to generate the required credentials file.

After following those guides, you can provide all the required information to the Terraform provider by
setting the following environment variables:

```shell
# Bash etc.
export GOOGLE_APPLICATION_CREDENTIALS=/path/to/creds.json
export GOOGLE_PROJECT=my-project
export GOOGLE_REGION=us-east1
export GOOGLE_ZONE=us-east1-b
```

The last three environment variables can alternatively be set directly in the provider declaration:

```terraform
provider "google" {
  project = "my-project"
  region  = "us-east1"
  zone    = "us-east1-b"
}

# ... Resources
```
