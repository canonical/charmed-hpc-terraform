# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

mock_provider "azurerm" {}
mock_provider "juju" {}

# The azurerm provider parses Azure resource IDs at plan time, so the mocked
# placeholders must be replaced with well-formed ARM IDs.
override_data {
  target = data.azurerm_virtual_network.nfs
  values = {
    id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/test-vnet"
  }
}

override_data {
  target = data.azurerm_subnet.nfs
  values = {
    id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/test-subnet"
  }
}

override_resource {
  target = azurerm_storage_account.nfs
  values = {
    id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Storage/storageAccounts/teststorage"
  }
}

override_resource {
  target = azurerm_private_dns_zone.nfs
  values = {
    id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Network/privateDnsZones/privatelink.file.core.windows.net"
  }
}

# Smoke test: the module plans with defaults and exposes the CC008 surface.
run "defaults" {
  command = plan

  variables {
    quota               = 100
    mountpoint          = "/srv/nfs"
    resource_group_name = "rg-test"
    subnet_info = {
      name                 = "test-subnet"
      virtual_network_name = "test-vnet"
    }
    model_uuid = "00000000-0000-0000-0000-000000000000"
  }

  assert {
    condition     = alltrue([for _, app in output.components : app != null])
    error_message = "Every component must map to a deployed application."
  }
}
