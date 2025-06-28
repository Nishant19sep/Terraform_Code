
# data "azurerm_network_security_group" "nsg" {
#   name                = "nsg-frontend"
#   resource_group_name = "rg-beni"
# }

resource "azurerm_network_interface" "ntnic" {
  name                = var.nic_name
  location            = var.nic_location
  resource_group_name = var.rg_name_nic

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.subnet_id.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = data.azurerm_public_ip.pip.id

}
}
resource "azurerm_network_interface_security_group_association" "nic_nsg_assoc" {
  network_interface_id      = azurerm_network_interface.ntnic.id
  network_security_group_id = data.azurerm_network_security_group.nsg.id
}
resource "azurerm_linux_virtual_machine" "vm_nt_todo" {
  name                = var.vm_name
  resource_group_name = var.rg_name
  location            = var.location_vm
  size                = var.vm_size
  admin_username      = data.azurerm_key_vault_secret.vm-un.value
  admin_password      = data.azurerm_key_vault_secret.vm-pwd.value
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.ntnic.id,
  ]


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  custom_data = base64encode(<<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y nginx
    systemctl enable nginx
    systemctl start nginx
  EOF
  )
}