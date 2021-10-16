# =============== Virtual Network ===============
resource "azurerm_virtual_network" "weight_tracker_VNet" {
  name                = var.virtual_network_name
  resource_group_name = var.rg_name
  location            = var.cloud_location
  address_space       = var.virtual_network_CIDR
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

# =============== Subnet Private ===============
resource "azurerm_subnet" "private" {
  name                 = var.private_subnet_name
  address_prefixes     = var.private_subnet_CIDR
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.weight_tracker_VNet.name
}

# =============== NSG for database ===============
resource "azurerm_network_security_group" "database_access" {
  name                = var.private_NSG_name
  location            = var.cloud_location
  resource_group_name = var.rg_name

  security_rule {
    name                       = "postgres"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5432"
    source_address_prefix      = element(var.public_subnet_CIDR, 0)
    destination_address_prefix = "*"
  }
}

# =============== private subnet  NSG association ===============
resource "azurerm_subnet_network_security_group_association" "to_private" {
  subnet_id                 = azurerm_subnet.private.id
  network_security_group_id = azurerm_network_security_group.database_access.id
}

# =============== Public IP ===============
resource "azurerm_public_ip" "to_front_lb" {
  name                = var.public_ip_to_front_LB_name
  location            = var.cloud_location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
}

# =============== Availabilty Set ===============
resource "azurerm_availability_set" "website" {
  name                = var.ava_set_name
  location            = var.cloud_location
  resource_group_name = var.rg_name
  platform_fault_domain_count = 2
  platform_update_domain_count = 3
  
  tags = var.instances_tags
}

# =============== NIC web VMs ===============
resource "azurerm_network_interface" "web_server" {
  count = 3
  name                = "VM_NIC_${count.index}"
  location            = var.cloud_location
  resource_group_name = var.rg_name
  ip_configuration {
    name                          = "internal_${count.index}"
    subnet_id                     = azurerm_subnet.public.id
    private_ip_address_allocation = "dynamic"
  }
}

# =============== NIC database VMs ===============
# resource "azurerm_network_interface" "database" {
#   name                = "database_VM_NIC"
#   location            = var.cloud_location
#   resource_group_name = var.rg_name
#   ip_configuration {
#     name                          = "internal_database"
#     subnet_id                     = azurerm_subnet.private.id
#     private_ip_address_allocation = "dynamic"
#   }
# }

# =============== Load balancer ===============
resource "azurerm_lb" "example" {
  name                = "TestLoadBalancer"
  location            = var.cloud_location
  resource_group_name = var.rg_name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.to_front_lb.id
    
  }
}
