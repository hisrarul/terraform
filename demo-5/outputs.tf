output "rg" {
  description = "Name of the resource group"
  value = "${azurerm_resource_group.main.id}"
}

output "vnet" {
  description = "Id of the virtual network"
  value = "${azurerm_virtual_network.main.id}"
}

output "subnet" {
  description = "Id of the subnet"
  value = "${azurerm_subnet.internal.id}"
}

output "networkinterface" {
  description = "Private ip addresses"
  value = "${azurerm_network_interface.main.private_ip_addresses}"
}

output "vm" {
  description = "Id of the vm"
  value = "${azurerm_virtual_machine.main.id}"
}
