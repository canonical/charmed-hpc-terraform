# AGENTS.md

Guidance for LLM coding agents working in this repository. Follow these
instructions together with `CONTRIBUTING.md`; do not treat generated output or
cached dependencies as source files.

## Project overview

This repository contains Terraform/OpenTofu modules for deploying Charmed HPC
components with the Juju Terraform provider, plus example deployments.

- `modules/controller/` bootstraps a Juju controller. It is intentionally
  different from the charm modules because no Juju model exists before
  bootstrap.
- `modules/slurm/` deploys the Slurm control plane and compute partitions.
- `modules/lustre/` deploys a Lustre server and filesystem client.
- `modules/nfs/{aws,azure,gcp}/` deploys cloud-specific NFS infrastructure and
  its Juju proxy/client charms.
- `examples/` contains standalone OpenTofu plans and Terragrunt stacks that
  consume the modules.

Charm-module inputs, outputs, documentation, and tests follow the CC008
conventions. Preserve existing public interfaces unless a breaking change is
intentional, and keep the controller module's bootstrap-specific interface
distinct from the charm modules.

## Use `just` for project tasks

The `justfile` is the supported interface for development tasks. Use its
recipes instead of manually invoking `tofu`, `terraform`, `terragrunt`,
`terraform-docs`, or `tflint`. The recipes select the correct module and
example directories, use the required flags, and prefer OpenTofu while falling
back to Terraform when necessary.

| Command | Purpose |
| --- | --- |
| `just help` | List the available recipes. |
| `just init` | Initialize all Terraform roots and Terragrunt stacks. |
| `just fmt` | Format the justfile, Terraform files, and Terragrunt files. |
| `just test` | Initialize and run every module's Terraform tests. |
| `just docs` | Regenerate every module README's terraform-docs sections. |
| `just check` | Run initialization, formatting and validation checks, Terragrunt validation, tflint, and documentation freshness checks. |
| `just clean` | Remove local Terraform/Terragrunt caches and state files. This is destructive; use only when cleanup is intended. |

Do not create ad-hoc shell loops that duplicate these recipes. If a recipe
cannot run because a required tool, credential, or network resource is
unavailable, report that limitation rather than replacing the recipe with an
unverified workaround.

## Making changes

1. Read the relevant module's `variables.tf`, `outputs.tf`, tests, and README
   before editing. Keep changes focused and consistent with existing module
   patterns.
2. Update module tests and affected examples when behavior or public interfaces
   change. Run `just test` for changes to module behavior or test definitions.
3. Run `just fmt` when files need formatting; do not hand-format generated
   documentation tables.
4. Add the full Apache-2.0 license header from `CONTRIBUTING.md` to every new
   source file, using the current year. When modifying an existing file, extend
   its copyright year range to include the current year.
5. Never edit or commit files under `.terraform/` or `.terragrunt-cache/`.
   These directories can contain stale copies of modules and are not source.

## README and breaking-change requirements

Every breaking module change must include corresponding documentation updates
in the same change. This includes renamed, removed, or retyped inputs and
outputs, changed defaults, and changed deployment behavior.

- Update the affected module README's hand-written usage and explanatory text.
- Update the root `README.md` and affected example READMEs when their usage or
  descriptions refer to the changed interface.
- Search all tracked documentation and examples for old input, output, and
  resource names; do not leave stale references behind.
- Run `just docs` to regenerate the terraform-docs sections. Only the content
  between the `BEGIN_TF_DOCS` and `END_TF_DOCS` markers is generated; review
  and edit surrounding prose manually when needed.
- Update `main.tftest.hcl` files and example plans so documentation, tests, and
  executable usage agree with the new interface.

`just docs` alone is not sufficient for breaking changes: it regenerates
schema tables but does not update hand-written examples or prose.

## Required completion checks

After finishing changes, run:

```shell
just check
```

If `just check` reports stale module documentation, or if inputs or outputs
changed, then run:

```shell
just docs
just check
```

The second `just check` is required to confirm that the regenerated docs and
all other checks pass. Do not claim completion while a required check is
failing or has not been run. If the environment prevents a command from
completing, report the exact command and error, along with any validation that
could not be performed.

When summarizing work, list the changed files, documentation updates, and the
`just` commands actually run. Do not commit changes unless the user explicitly
asks for a commit.
