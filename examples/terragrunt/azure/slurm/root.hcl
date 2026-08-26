# Shared configuration for all units that deploy into the bootstrapped
# controller. Included by every workload unit in this stack.
#
# Declares the controller dependency and generates a providers.tf that
# configures the juju provider from the controller unit's outputs, so the
# sourced Terraform modules need no connection variable of their own.

dependency "controller" {
  config_path = "${get_terragrunt_dir()}/../controller"

  # Mock outputs let init and validate succeed before the controller unit has
  # been applied. Apply always uses the real outputs.
  mock_outputs = {
    connection = {
      controller_addresses = "localhost:17070"
      username             = "admin"
      password             = "changeme"
      ca_certificate       = "changeme"
    }
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate"]
}

generate "providers" {
  path      = "providers.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
    provider "juju" {
      controller_addresses = ${jsonencode(dependency.controller.outputs.connection.controller_addresses)}
      username             = ${jsonencode(dependency.controller.outputs.connection.username)}
      password             = ${jsonencode(dependency.controller.outputs.connection.password)}
      ca_certificate       = ${jsonencode(dependency.controller.outputs.connection.ca_certificate)}
      skip_failed_deletion = true
    }
  EOF
}
