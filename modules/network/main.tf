# =============== Virtual Network ===============
resource "azurerm_virtual_network" "weight_tracker_VNet" {
  name                = var.virtual_network_name
  resource_group_name = var.rg_name
  location            = var.cloud_location
  address_space       = var.virtual_network_CIDR
  # tags                = var.instances_tags
}

# =============== Subnet Public ===============
resource "azurerm_subnet" "public" {
  name                 = var.public_subnet_name
  address_prefixes     = var.public_subnet_CIDR
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.weight_tracker_VNet.name
}
# =============== NSG for web ===============
resource "azurerm_network_security_group" "public_Access" {
  name                = var.public_NSG_name
  location            = var.cloud_location
  resource_group_name = var.rg_name

  security_rule {
    name                       = "port_8080"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  
}
# =============== Subnet Public NSG association ===============

resource "azurerm_subnet_network_security_group_association" "to_public" {
  subnet_id                 = azurerm_subnet.public.id
  network_security_group_id = azurerm_network_security_group.public_Access.id
}
