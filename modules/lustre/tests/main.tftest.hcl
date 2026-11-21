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
    expose_endpoints = ["lustre_server_filesystem"]
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
    expose_endpoints = ["filesystem_client_mount"]
  }

  expect_failures = [var.expose_endpoints]
}

# A typo'd endpoint key must fail validation instead of a raw indexing error.
run "offer_invalid_endpoint" {
  command = plan

  variables {
    model_uuid = "00000000-0000-0000-0000-000000000000"
    client = {
      mountpoint = "/srv/lustre"
    }
    expose_endpoints = ["lustre_server_filesytem"]
  }

  expect_failures = [var.expose_endpoints]
}
