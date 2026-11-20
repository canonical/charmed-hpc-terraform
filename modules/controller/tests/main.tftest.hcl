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
