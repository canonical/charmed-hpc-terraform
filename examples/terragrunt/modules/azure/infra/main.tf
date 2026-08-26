# Azure network infrastructure and Juju model shared by the workload units.

resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "this" {
  name                = var.virtual_network_name
  address_space       = var.address_space
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  subnet              = []
}

resource "azurerm_network_security_group" "this" {
  name                = var.network_security_group_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  security_rule {
    name                       = "Allow-SSH-Internet"
    description                = "Open SSH inbound ports"
    protocol                   = "Tcp"
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "22"
    access                     = "Allow"
    priority                   = 100
    direction                  = "Inbound"
  }
}

resource "azurerm_subnet" "this" {
  name                                          = var.subnet_name
  resource_group_name                           = azurerm_resource_group.this.name
  virtual_network_name                          = azurerm_virtual_network.this.name
  address_prefixes                              = var.subnet_address_prefixes
  private_endpoint_network_policies             = "Enabled"
  private_link_service_network_policies_enabled = true
}

resource "azurerm_subnet_network_security_group_association" "this" {
  subnet_id                 = azurerm_subnet.this.id
  network_security_group_id = azurerm_network_security_group.this.id
}

resource "juju_model" "this" {
  name = var.model_name

  cloud {
    name   = "azure"
    region = "eastus"
  }

  config = {
    resource-group-name = azurerm_resource_group.this.name
    network             = azurerm_virtual_network.this.name
    # Work around Azure storage pool requests hanging. MySQL deployment gets
    # stuck at "agent initialising" otherwise.
    storage-default-filesystem-source = "rootfs"
  }
}
