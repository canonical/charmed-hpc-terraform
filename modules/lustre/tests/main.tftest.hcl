# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

mock_provider "juju" {}

# Smoke test: the module plans with defaults and exposes the CC008 surface.
run "defaults" {
  command = plan

  variables {
    model_uuid = "00000000-0000-0000-0000-000000000000"
    client = {
      mountpoint = "/srv/lustre"
    }
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

# A valid offer endpoint plans and creates exactly one offer.
run "offer_valid_endpoint" {
  command = plan

  variables {
    model_uuid = "00000000-0000-0000-0000-000000000000"
    client = {
      mountpoint = "/srv/lustre"
    }
    offered_endpoints = ["lustre_server_filesystem"]
  }

  assert {
    condition     = length(output.offers) == 1
    error_message = "A valid endpoint key must create exactly one cross-model offer."
  }
}

# A documented-but-non-offerable endpoint key (container-scoped, from the
# `requires` output) must fail validation.
run "offer_non_offerable_endpoint" {
  command = plan

  variables {
    model_uuid = "00000000-0000-0000-0000-000000000000"
    client = {
      mountpoint = "/srv/lustre"
    }
    offered_endpoints = ["filesystem_client_mount"]
  }

  expect_failures = [var.offered_endpoints]
}

# A typo'd endpoint key must fail validation instead of a raw indexing error.
run "offer_invalid_endpoint" {
  command = plan

  variables {
    model_uuid = "00000000-0000-0000-0000-000000000000"
    client = {
      mountpoint = "/srv/lustre"
    }
    offered_endpoints = ["lustre_server_filesytem"]
  }

  expect_failures = [var.offered_endpoints]
}
