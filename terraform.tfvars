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
private_NSG_name     = "postgresqlNSG"
# load balancer
public_ip_to_front_LB_name = "PublicIPForLB"
ava_set_name = "ASfront"
nic_database_name = "VMdatabasenic"
