# terraform-with-azure
exploring the usage of Terraform and Azure

## downloads and environment

### Install Terraform CLI
First we will need to download the Terraform CLI [Here](https://www.terraform.io/downloads.html) and choose the OS.
Second go to [Here](https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/azure-get-started) for Terraform install explaination. 
To see if the installation go well, type
```
terraform -help
```

### Insatll Azure CLI
Go to [Here](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) for insatll Azure CLI guide.
and then run 
```az login```
and follow the login instractions.

## Windows Command Aliases
A command alias directly references another existing command. For example, the alias below takes terraform, 
which is a long command name, and shrinks it down into tf – something less annoying to type! 
```
New-Alias -Name "tf" -Value "terraform"
```
we also create function so it will execute a full caommand
Inserting something unique into a function name to avoid conflict with other cmdlets. I will use MT, my initials, to make determining who to blame easier. 🙂
```
function NAME_OF_THE_FUNCTION { THE_COMMAND }
New-Alias -Name "NAME_OF_THE_ALIAS" -Value NAME_OF_THE_FUNCTION
```
In this example, I create two functions to handle adding untracked files and creating a new commit.
The second function, `Add-MTGitCommit`, uses the `$args` variable to allow for a custom commit message when run.
```
function Add-MTGitAll { git add . }
New-Alias -Name "gita" -Value Add-MTGitAll

function Add-MTGitCommit { git commit -s -m $args }
New-Alias -Name "gitc" -Value Add-CMTitCommit
```

I am then able to use gitc "A wonderfully crafted commit message!" to entertain my fellow collaborators.


## Basic commands and configuration 

In your terminal go to your desire folder, create a file `FILE_NAME.tf` and open with VsCode. in my case typing `code .` will open the VsCode.
We will use Azure as a provider, [Here](https://www.terraform.io/docs/language/providers/configuration.html) you can read more about this.
```
# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}
```
note: all the command here is after we decaler alias, if you didn't use alias you will need to type `terraform` insted of just `tf`.
in your terminal type
```
tf init
```
Initiat the configuration
```
tf fmt
```
Format all the blocks and code
```
tf validate
```
Make sure the code is currect
```
tf plan
```

```
tf apply
```
Applay the code and configuration, you will prompt with Yes No question.
```
tf destroy
```
destroy the configuration and delet it from the cloud.

### NOTE:
If you using `.tfvars` suffix and the variables values doesn't loaded you have two option mention [Here](https://discuss.hashicorp.com/t/values-from-tfvars-not-getting-loaded/24040/2) and in my case i choose changing the suffix to `.auto.tfvars`

# Terraform project
We will configur the following diagram
![conf](https://user-images.githubusercontent.com/71608579/136935658-f5c64474-e621-4d4c-81a3-bba77614419f.png)

### Create Resource Group
```
resource "azurerm_resource_group" "webAppRG" {
  name     = "weight_tracker_app_RG_eith_TF"
  location = "switzerlandnorth"
  tags = {
    "Owner"  = "Matan Tal"
    "Source" = "Terraform"
  }
}
```

## Create Network Security Group
```
resource "azurerm_network_security_group" "webNSG" {
  name = "webNSG"
  
  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
```
we can specify the SNG rule in different section like so

```
resource "azurerm_network_security_rule" "example" {
  name                        = "test123"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.example.name
  network_security_group_name = azurerm_network_security_group.example.name
}
```

## Create Virtual Network
```
resource "azurerm_virtual_network" "VNet" {
  name = "vnet"
  resource_group_name = azurerm_resource_group.webAppRG.name
  location            = azurerm_resource_group.webAppRG.location
  address_space       = ["10.0.0.0/16"]

  subnet {
    name           = "dataSubnet"
    address_prefix = "10.0.1.0/24"
    security_group = azurerm_network_security_group.dataNSG
  }
  subnet {
    name           = "webSubnet"
    address_prefix = "10.0.2.0/24"
    security_group = azurerm_network_security_group.webNSG
  }
  tags = {
    "Owner"  = "Matan Tal"
    "Part" = "First project"
  }

}
```

we can specefy the subnet in separet section like so and then mention the VNet the subnet belong
```
resource "azurerm_subnet" "example" {
  name                 = "frontend"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}
```
## add NIC for the VM's
```
resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}
```

## Create VM for linux
```
resource "azurerm_linux_virtual_machine" "example" {
  name                = "example-machine"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}
```

## Create Availability set

resource "azurerm_availability_set" "example" {
  name                = "example-aset"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  tags = {
    environment = "Production"
  }
}
