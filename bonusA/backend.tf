resource "azurerm_storage_account" "state_storage" {
  name                     = "statestoracc"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "state_container" {
  name                  = "terraform-states"
  storage_account_name  = azurerm_storage_account.state_storage.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "state_blob" {
  name                   = "my-awesome-content.zip"
  storage_account_name   = azurerm_storage_account.state_storage.name
  storage_container_name = azurerm_storage_container.state_container.name
  type                   = "Block"
  # source                 = "some-local-file.zip"
}

terraform {
  backend "remote_azure_blob" {
    storage_account_name = "terraformproj"
    container_name       = "terraform-states"
    key                  = "prod.terraform.tfstate"


  }
}