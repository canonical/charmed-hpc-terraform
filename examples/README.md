# Charmed HPC Terraform Examples

This directory contains example deployments using [Terragrunt](https://terragrunt.gruntwork.io/) for deploying Charmed HPC components.

## Structure

The examples are organized using Terragrunt to keep configurations DRY (Don't Repeat Yourself):

```
examples/
├── terragrunt.hcl          # Root configuration with common settings
├── nfs/
│   ├── aws/
│   │   ├── terragrunt.hcl  # AWS-specific Terragrunt config
│   │   ├── main.tf         # Terraform resources
│   │   └── README.md       # AWS NFS example documentation
│   ├── gcp/
│   │   ├── terragrunt.hcl  # GCP-specific Terragrunt config
│   │   ├── main.tf         # Terraform resources
│   │   └── README.md       # GCP NFS example documentation
│   └── azure/
│       ├── terragrunt.hcl  # Azure-specific Terragrunt config
│       ├── main.tf         # Terraform resources
│       └── README.md       # Azure NFS example documentation
└── slurm/
    ├── terragrunt.hcl      # Slurm-specific Terragrunt config
    ├── main.tf             # Terraform resources
    └── README.md           # Slurm example documentation
```

## Prerequisites

Before using these examples, ensure you have:

1. A Juju 3.x controller [bootstrapped](https://juju.is/docs/juju/bootstrapping) on your cloud
2. Terragrunt installed:
   ```bash
   # Install Terragrunt
   # See https://terragrunt.gruntwork.io/docs/getting-started/install/ for installation instructions
   ```
3. OpenTofu or Terraform installed:
   ```bash
   # Install OpenTofu
   sudo snap install --classic opentofu
   
   # Or install Terraform
   # See https://developer.hashicorp.com/terraform/install for installation instructions
   ```

## Usage

Each example directory contains its own README with specific instructions. The general workflow is:

```bash
# Navigate to the example directory
cd examples/<example-name>

# Initialize Terragrunt (downloads providers and modules)
terragrunt init

# Plan the deployment
terragrunt plan

# Apply the deployment
terragrunt apply
```

## Benefits of Using Terragrunt

- **DRY Configuration**: Common provider configurations are defined once in the root `terragrunt.hcl`
- **Generated Files**: Provider and version configurations are automatically generated
- **Consistent Structure**: All examples follow the same organizational pattern
- **Easy Variable Management**: Use `TG_VAR_` prefix for environment variables

## Available Examples

- **nfs/aws**: Deploy an NFS server on AWS with VPC peering to Juju controller
- **nfs/gcp**: Deploy an NFS server on Google Cloud Platform
- **nfs/azure**: Deploy an NFS server on Microsoft Azure
- **slurm**: Deploy a complete Slurm cluster with MySQL backend
