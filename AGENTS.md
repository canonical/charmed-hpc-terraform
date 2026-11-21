## Overview

This repository contains Terraform/OpenTofu modules for deploying Charmed HPC
components with the Juju Terraform provider, plus standalone OpenTofu and
Terragrunt example deployments. Follow these instructions together with
`CONTRIBUTING.md`.

The source layout is:

```text
.
├── modules
│   ├── controller       # Bootstrap a Juju controller; not a charm module
│   ├── slurm            # Slurm control plane and compute partitions
│   ├── lustre           # Lustre server and filesystem client
│   └── nfs
│       ├── aws          # AWS NFS infrastructure and Juju proxy/client charms
│       ├── azure        # Azure NFS infrastructure and Juju proxy/client charms
│       └── gcp          # GCP NFS infrastructure and Juju proxy/client charms
├── examples
│   ├── lustre           # Standalone Lustre deployment plans
│   ├── nfs              # Standalone NFS deployment plans
│   ├── slurm            # Standalone Slurm deployment plan
│   └── terragrunt       # Terragrunt stacks for Azure and LXD
├── justfile             # Supported development task interface
└── CONTRIBUTING.md      # Contribution and license-header requirements
```

The project uses:

- OpenTofu (preferred) or Terraform for module validation and testing.
- Terragrunt for validating the example stacks.
- `just` as the task runner (see `justfile`).
- `terraform-docs` for generated module documentation.
- `tflint` for Terraform linting.
- The Juju Terraform provider for Juju resources.

## Module conventions

Charm-module inputs, outputs, documentation, and tests follow the CC008
conventions. Preserve existing public interfaces unless a breaking change is
intentional. The controller module is intentionally different: it bootstraps a
Juju controller before any model exists, so charm-module inputs such as
`model_uuid` do not apply to it.

When creating, reviewing, or restructuring a charm Terraform module, follow the
[`create-charm-terraform-module` skill](https://github.com/canonical/hpc-team/blob/main/.agents/skills/create-charm-terraform-module/SKILL.md).
It codifies the CC008 file layout, input/output contracts, documentation
structure, versioning conventions, and validation requirements.

Read the relevant module's `variables.tf`, `outputs.tf`, tests, and README
before editing. Keep changes focused and consistent with existing module
patterns. Update module tests and affected examples when behavior or public
interfaces change.

Never edit or commit files under `.terraform/` or `.terragrunt-cache/`. These
directories can contain stale copies of modules and are not source files.

## License headers

Every new source file must carry the full Apache-2.0 license header from
`CONTRIBUTING.md`, with the copyright owner set to the organization you are
contributing on behalf of and the year set to the current year. When modifying
an existing file whose copyright year is stale, extend the range to include the
current year (for example, `2025` to `2025-2026`).

## Build and test commands

The `justfile` is the supported interface for development tasks. Use its
recipes instead of manually invoking `tofu`, `terraform`, `terragrunt`,
`terraform-docs`, or `tflint`. The recipes select the correct module and
example directories, use the required flags, and handle the OpenTofu/Terraform
fallback.

```bash
just help    # List available recipes.
just init    # Initialize all Terraform roots and Terragrunt stacks.
just fmt     # Format the justfile, Terraform files, and Terragrunt files.
just test    # Initialize and run every module's Terraform tests.
just docs    # Regenerate every module README's terraform-docs sections.
just check   # Run init, fmt/validate, Terragrunt, tflint, and docs checks.
just clean   # Destructive: remove local Terraform/Terragrunt caches and state.
```

Do not create ad-hoc shell loops that duplicate these recipes. If a recipe
cannot run because a required tool, credential, or network resource is
unavailable, report that limitation rather than replacing the recipe with an
unverified workaround.

## README and breaking changes

Every breaking module change must include corresponding documentation updates
in the same change. This includes renamed, removed, or retyped inputs and
outputs, changed defaults, and changed deployment behavior.

- Update the affected module README's hand-written usage and explanatory text.
- Update the root `README.md` and affected example READMEs when their usage or
  descriptions refer to the changed interface.
- Search all tracked documentation and examples for old input, output, and
  resource names; do not leave stale references behind.
- Update `main.tftest.hcl` files and example plans so documentation, tests, and
  executable usage agree with the new interface.
- Run `just docs` to regenerate the terraform-docs sections. Only content
  between the `BEGIN_TF_DOCS` and `END_TF_DOCS` markers is generated; review
  and edit surrounding prose manually when needed.

`just docs` alone is not sufficient for breaking changes: it regenerates schema
tables but does not update hand-written examples or prose.

## Development workflow

1. Read the relevant module and tests, then implement focused changes following
   the module conventions above.
2. Update module tests, examples, and documentation for any behavior or public
   interface change. Breaking changes must satisfy all requirements in the
   README section above.
3. Run `just test` for changes to module behavior or test definitions.
4. Run `just fmt` when files need formatting. Do not hand-format generated
   documentation tables.
5. After finishing changes, run `just check` and fix any failures.
6. If `just check` reports stale module documentation, or if inputs or outputs
   changed, run `just docs`, review the generated changes, and run `just check`
   again. The second check is required to confirm that regenerated docs and all
   other checks pass.
7. Repeat these steps for each new or modified file as needed. Do not claim
   completion while a required check is failing or has not been run. If the
   environment prevents a command from completing, report the exact command and
   error, along with any validation that could not be performed.

When summarizing work, list the changed files, documentation updates, and the
`just` commands actually run.

## Commit conventions

Use Conventional Commits prefixes for commit messages:

- `feat:` -- New user-facing feature.
- `fix:` -- Bug fix.
- `test:` -- Add or modify tests only.
- `chore:` -- Maintenance tasks (formatting, dependency updates, etc.).
- `docs:` -- Documentation only.
- `refactor:` -- Code change that neither fixes a bug nor adds a feature.
- `ci:` -- CI/CD pipeline changes.

Scopes are allowed (for example, `chore(deps):`, `chore(fmt):`, or
`feat(slurm):`). Use `!` for breaking changes (for example, `feat!:`).

### Commit trailers

- Commits must be signed off (`Signed-off-by:` trailer) **by the human**.
  Agents must never add a `Signed-off-by:` trailer on the human's behalf.
- Agents must include an `Assisted-by:` trailer identifying the agent and
  model.
- Order trailers as: `Assisted-by:` first, then the human's
  `Signed-off-by:` last (added by the human).

Format:

    Assisted-by: AGENT_NAME:MODEL_VERSION[:MODEL_VARIANT]

- `AGENT_NAME`: The AI tool (for example, `zed-agent`).
- `MODEL_VERSION`: The specific model version used.
- `MODEL_VARIANT`: The variant of the model version used (for example,
  `low`, `medium`, or `high`). Optional.

Other rules:

- Commit messages must be ASCII only.
- Keep PRs small and focused.
- Maintain a linear git history.
- All pre-commit checks must pass.
- Do not commit changes unless the user explicitly asks for a commit.

## Further information

- [CC008 Charm Terraform Standards and `create-charm-terraform-module` skill](https://github.com/canonical/hpc-team/blob/main/.agents/skills/create-charm-terraform-module/SKILL.md)
- [Juju Terraform provider documentation](https://registry.terraform.io/providers/juju/juju/latest/docs)
- [OpenTofu documentation](https://opentofu.org/docs/)
- [Terragrunt documentation](https://terragrunt.gruntwork.io/docs/)
- [Charmed HPC documentation](https://canonical-charmed-hpc.readthedocs-hosted.com/latest)
