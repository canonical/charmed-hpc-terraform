output "model_uuid" {
  description = "UUID of the Juju model."
  value       = juju_model.this.uuid
}

output "resource_group_name" {
  description = "Name of the Azure resource group."
  value       = azurerm_resource_group.this.name
}

output "subnet_info" {
  description = "Information about the Azure subnet, suitable for the NFS module's subnet_info input."
  value = {
    name                 = azurerm_subnet.this.name
    virtual_network_name = azurerm_subnet.this.virtual_network_name
  }
}
