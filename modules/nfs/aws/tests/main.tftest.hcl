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

mock_provider "aws" {}
mock_provider "juju" {}

# Mocked placeholder values are not valid CIDR blocks; the vendored EFS module
# validates them, so give the mocked VPC a realistic address space.
override_data {
  target = data.aws_vpc.this
  values = {
    cidr_block = "10.0.0.0/16"
  }
}

# Smoke test: the module plans with defaults and exposes the CC008 surface.
run "defaults" {
  command = plan

  variables {
    vpc_id     = "vpc-00000000"
    subnet_id  = "subnet-00000000"
    mountpoint = "/srv/nfs"
    model_uuid = "00000000-0000-0000-0000-000000000000"
  }

  assert {
    condition     = alltrue([for _, app in output.components : app != null])
    error_message = "Every component must map to a deployed application."
  }
}
