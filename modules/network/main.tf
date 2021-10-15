# =============== Virtual Network ===============
resource "azurerm_virtual_network" "weight_tracker_VNet" {
  name                = var.virtual_network_name
  resource_group_name = var.rg_name
  location            = var.cloud_location
  address_space       = var.virtual_network_CIDR
  tags = var.instances_tags
}
