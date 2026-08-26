# Deploy MySQL into the model created by the infra unit. It provides the
# backing database for the Slurm accounting node.

include "root" {
  path = "../root.hcl"
}

dependency "infra" {
  config_path = "../infra"

  mock_outputs = {
    model_uuid = "00000000-0000-0000-0000-000000000000"
  }
  # The model UUID is all this unit needs from infra, so mocked outputs also
  # work for plan.
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
}

inputs = {
  model        = dependency.infra.outputs.model_uuid
  app_name     = "mysql"
  base         = "ubuntu@26.04"
  channel      = "8.4/edge"
  units        = 1
  storage_size = "10G"
}

terraform {
  source = "git::https://github.com/canonical/mysql-operators//machines/terraform?ref=33d381861060a74c10681eae2feca1ce2ef0c105"
}
