# resource "azurerm_storage_account" "example" {
#   name                     = "examplestoracc"
#   resource_group_name      = azurerm_resource_group.example.name
#   location                 = azurerm_resource_group.example.location
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
# }

# resource "azurerm_storage_container" "example" {
#   name                  = "content"
#   storage_account_name  = azurerm_storage_account.example.name
#   container_access_type = "private"
# }

# resource "azurerm_storage_blob" "example" {
#   name                   = "my-awesome-content.zip"
#   storage_account_name   = azurerm_storage_account.example.name
#   storage_container_name = azurerm_storage_container.example.name
#   type                   = "Block"
#   source                 = "some-local-file.zip"
# }



terraform {
  backend "azurerm" {
    storage_account_name = "terraformproj"
    container_name       = "containproj"
    key                  = "prod.terraform.tfstate"

    # rather than defining this inline, the SAS Token can also be sourced
    # from an Environment Variable - more information is available below.
    sas_token = "?sv=2020-08-04&ss=bfqt&srt=co&sp=rwdlacuptfx&se=2021-10-31T22:12:55Z&st=2021-10-17T13:12:55Z&spr=https&sig=AmS7wWJOUhlFR%2BhanrR586pKLB95eKC0fnO0tGDU6s4%3D"
  }
}
