# Deploy the Slurm cluster on the controller bootstrapped by the controller
# unit, into the model created by the infra unit. This unit runs after the
# controller, infra, and mysql units; the nfs unit mounts the share on the
# applications this unit deploys.

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

dependency "mysql" {
  config_path = "../mysql"

  mock_outputs = {
    app_name = "mysql"
    provides = {
      database = "database"
    }
  }
  # MySQL only deploys Juju applications (no Azure data sources), so mocked
  # outputs also work for plan.
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
}

inputs = {
  model_uuid = dependency.infra.outputs.model_uuid

  database_backend = {
    name     = dependency.mysql.outputs.app_name
    endpoint = dependency.mysql.outputs.provides.database
  }

  # Optional settings for the controller node.
  controller = {
    app_name = "slurmctld"
  }

  # Optional settings for the database node.
  database = {
    app_name = "slurmdbd"
  }

  # Optional settings for the REST API node.
  rest_api = {
    app_name = "slurmrestd"
  }

  # Optional settings for the kiosk node.
  kiosk = {
    app_name = "sackd"
    units    = 1
  }

  # Compute partitions to be deployed.
  compute_partitions = {
    "cpu" : {
      units = 1,
    },
    "gpu" : {
      units = 1,
    }
  }
}

terraform {
  source = "../../../../..//modules/slurm"
}
