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