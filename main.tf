# =============== Resource group ===============
resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.cloud_location
}