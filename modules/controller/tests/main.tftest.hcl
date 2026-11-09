# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

mock_provider "juju" {}

# Smoke test: the module plans with defaults and exposes its outputs.
run "defaults" {
  command = plan

  variables {
    controller_name = "test-controller"
    cloud = {
      name       = "localhost"
      type       = "lxd"
      auth_types = ["empty"]
    }
    cloud_credential = {
      name       = "localhost"
      auth_type  = "empty"
      attributes = {}
    }
  }

  assert {
    condition     = output.controller_uuid != null && output.api_addresses != null
    error_message = "The bootstrapped controller details must be exposed."
  }

  assert {
    condition     = output.juju_data_dir == null
    error_message = "No Juju data directory must be written by default."
  }
}
