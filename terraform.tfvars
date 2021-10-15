rg_name        = "webApp_with_terraform"
cloud_location = "switzerlandnorth"
# tags
instances_tags = {
  Owner = "Matan_Tal"
  Part  = "First_project"
}
# VNet
virtual_network_CIDR = ["10.0.0.0/16"]
virtual_network_name = "applicationVNet"
# subnet
public_subnet_CIDR   = ["10.0.2.0/24"]
public_subnet_name   = "public"
private_subnet_CIDR  = ["10.0.1.0/24"]
private_subnet_name  = "private"
# NSG
public_NSG_name      = "webAppNSG"