resource "azurerm_network_interface" "nic" {
  name                = var.nic_name
  location            = "indonesiacentral"
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = var.ipconfig_name
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = data.azurerm_public_ip.pip.id
  }
}

resource "azurerm_linux_virtual_machine" "Virtualmachine" {
  name                = var.vm_name
  resource_group_name = var.rg_name
  location            = var.vm_location
  size                = "Standard_F2"
  disable_password_authentication = false
  admin_username      = data.azurerm_key_vault_secret.vm_id_secret.value
  admin_password      = data.azurerm_key_vault_secret.vm_password.value
  network_interface_ids = [
    azurerm_network_interface.nic.id,
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
}