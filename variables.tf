variable "rg_name" {
  type        = string
  description = "resource group name"
}
variable "cloud_location" {
  type        = string
  description = "resource location"
}
variable "instances_tags" {
  type = object({
    Owner = string
    Part  = string
  })
  description = "Tags Owner and Part tags"
}
# virtual network
variable "virtual_network_CIDR" {
  type        = list(string)
  description = "virtual network address space"
}
variable "virtual_network_name" {
  type        = string
  description = "Virtual Network name"
}

# Subnets variables
variable "public_subnet_CIDR" {
  type        = list(string)
  description = "public subnet addr prefixs"
}
variable "public_subnet_name" {
  type        = string
  description = "public subnet name"
}
variable "private_subnet_name" {
  type        = string
  description = "private subnet name"
}
variable "private_subnet_CIDR" {
  type        = list(string)
  description = "private subnet addr prefixs"
}
# NSG
variable "public_NSG_name" {
  type        = string
  description = "Public NSG name"
}
variable "private_NSG_name" {
  type        = string
  description = "private NSG name"
}
# public IP
variable "public_ip_to_front_LB_name" {
  type        = string
  description = "public IP to front load balancer"
}
# availabilty set
variable "ava_set_name" {
  type        = string
  description = "availability set name"
}

# variable "vmSize" {
#   type        = string
#   description = "virtual machine size"
# }
# variable "user_name" {
#   type        = string
#   description = "User name"
#   default     = "username"
# }

# # disk
# variable "disk_caching" {
#   type        = string
#   description = "Disk caching"
# }
# variable "disk_storage_account_type" {
#   type        = string
#   description = "Disk storage account type"
# }
# variable "admin_pass" {
#   type        = string
#   description = "User password"
# }

# # source image reference
# variable "os_source_image_publisher" {
#   type        = string
#   description = "image publisher"
# }
# variable "os_source_image_sku" {
#   type        = string
#   description = "image sku"
# }
# variable "os_source_image_offer" {
#   type        = string
#   description = "image offer"
# }
# variable "os_source_image_version" {
#   type        = string
#   description = "image version"
# }
# variable "disable_password_auth" {
#   type        = bool
#   description = "disable_password_authentication"
# }