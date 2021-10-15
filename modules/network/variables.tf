# resource group
variable "rg_name" {
  type        = string
  description = "resource group name"
}
variable "cloud_location" {
  type        = string
  description = "resource location"
}
# Virtual Network variables
variable "virtual_network_CIDR" {
  type        = list(string)
  description = "virtual network address space"
}
variable "virtual_network_name" {
  type        = string
  description = "Virtual Network name"
}
variable "instances_tags" {
  type = object({
    Owner = string
    Part  = string
  })
  description = "Tags Owner and Part tags"
}
