# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

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
