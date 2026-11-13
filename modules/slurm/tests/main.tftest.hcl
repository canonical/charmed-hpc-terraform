# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

mock_provider "juju" {}

# Smoke test: the module plans with defaults and exposes the CC008 surface.
run "defaults" {
  command = plan

  variables {
    model_uuid       = "00000000-0000-0000-0000-000000000000"
    database_backend = { name = "mysql", endpoint = "database" }
  }

  assert {
    condition     = alltrue([for _, app in output.components : app != null])
    error_message = "Every component must map to a deployed application."
  }

  assert {
    condition     = output.offers == {}
    error_message = "No cross-model offers are created by default."
  }
}

# Cross-model database backend and all valid offer endpoints both plan.
# Offering every key of `local.offerable_endpoints` also catches drift
# between the validation and the locals.
run "offer_valid_endpoint" {
  command = plan

  variables {
    model_uuid        = "00000000-0000-0000-0000-000000000000"
    database_backend  = { offer_url = "admin/model.database" }
    offered_endpoints = ["sackd_metrics_endpoint", "slurmctld_influxdb", "slurmctld_smtp"]
  }

  assert {
    condition     = length(output.offers) == 3
    error_message = "All offerable endpoint keys must create exactly one cross-model offer each."
  }
}

# A documented-but-non-offerable endpoint key (container-scoped, from the
# `requires` output) must fail validation.
run "offer_non_offerable_endpoint" {
  command = plan

  variables {
    model_uuid        = "00000000-0000-0000-0000-000000000000"
    database_backend  = { name = "mysql" }
    offered_endpoints = ["slurmctld_cos_agent"]
  }

  expect_failures = [var.offered_endpoints]
}

# `name` and `offer_url` are mutually exclusive.
run "database_backend_name_and_offer_url" {
  command = plan

  variables {
    model_uuid       = "00000000-0000-0000-0000-000000000000"
    database_backend = { name = "mysql", offer_url = "admin/model.database" }
  }

  expect_failures = [var.database_backend]
}

# `offering_controller` only makes sense together with `offer_url`.
run "database_backend_controller_without_offer_url" {
  command = plan

  variables {
    model_uuid       = "00000000-0000-0000-0000-000000000000"
    database_backend = { name = "mysql", offering_controller = "other-controller" }
  }

  expect_failures = [var.database_backend]
}

# slurmdbd does not support HA setups.
run "database_ha_rejected" {
  command = plan

  variables {
    model_uuid       = "00000000-0000-0000-0000-000000000000"
    database_backend = { name = "mysql" }
    database         = { units = 2 }
  }

  expect_failures = [var.database]
}

# slurmrestd does not support HA setups.
run "rest_api_ha_rejected" {
  command = plan

  variables {
    model_uuid       = "00000000-0000-0000-0000-000000000000"
    database_backend = { name = "mysql" }
    rest_api         = { machines = ["0", "1"] }
  }

  expect_failures = [var.rest_api]
}
