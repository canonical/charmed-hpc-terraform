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
