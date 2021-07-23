##################
## NETWORK MAIN ##
##################

# Azure Main Resource Group Creation
resource "azurerm_resource_group" "main" {
  name     = var.prefix
  location = var.location
  tags     = var.tags
}

# Azure Main Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = var.tags
}

# DMZ Network
resource "azurerm_subnet" "DMZnetwork" {
  name                 = "DMZnetwork"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Windows Server Virtual Subnet
resource "azurerm_subnet" "defaultSubnet" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.0.0/24"]
}

##############
## SECURITY ##
##############



#####################
## STORAGE ACCOUNT ##
#####################

# Storage Account Random ID Generator
resource "random_id" "randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.main.name
  }

  byte_length = 8
}

# ADFS Storage Account Creation
resource "azurerm_storage_account" "adfsstorage" {
  name                     = "adfs${random_id.randomId.hex}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = var.location
  account_replication_type = "LRS"
  account_tier             = "Standard"
  tags                     = var.tags
}