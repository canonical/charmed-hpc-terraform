# Deploy a Lustre filesystem on the controller bootstrapped by the controller
# unit. This unit runs second: the dependency forces it to run after the
# controller is up, and the example's juju provider is configured from the
# controller unit's outputs, passed in as the `connection` variable.
#
# Azure credentials for the azurerm provider come from the standard ARM_*
# environment variables.

dependency "controller" {
  config_path = "./controller"

  # Mock outputs let init and validate succeed before the controller unit has
  # been applied.
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

inputs = {
  connection = dependency.controller.outputs.connection
}

terraform {
  source = "../../../..//examples/lustre/azure"
}
