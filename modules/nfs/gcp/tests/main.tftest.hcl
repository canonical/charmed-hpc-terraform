# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

mock_provider "google" {}
mock_provider "juju" {}

# The mocked filestore instance computes an empty IP address list, but the
# nfs-server-proxy needs an address to point at.
override_resource {
  target = google_filestore_instance.nfs
  values = {
    networks = {
      ip_addresses = ["10.128.0.2"]
    }
  }
}

# Smoke test: the module plans with defaults and exposes the CC008 surface.
run "defaults" {
  command = plan

  variables {
    network     = "test-network"
    tier        = "STANDARD"
    capacity_gb = 2560
    mountpoint  = "/srv/nfs"
    model_uuid  = "00000000-0000-0000-0000-000000000000"
  }

  assert {
    condition     = alltrue([for _, app in output.components : app != null])
    error_message = "Every component must map to a deployed application."
  }
}
