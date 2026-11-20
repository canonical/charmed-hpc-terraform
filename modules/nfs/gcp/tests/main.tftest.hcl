# Copyright 2026 Canonical Ltd.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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
