# =============== Virtual Machine ===============
resource "azurerm_linux_virtual_machine" "webAppWT" {
  name                = "vn_name"
  resource_group_name = var.rg_name
  location            = var.cloud_location
  size                = var.vm_size
  admin_username      = var.user_name
  admin_password = var.admin_pass
  disable_password_authentication = var.disable_password_auth
  network_interface_ids = var.nic_id
  availability_set_id = var.availability_id
  

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "20.04-LTS"
    version   = "latest"
  }
  
}