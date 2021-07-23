#######################
## DOMAIN CONTROLLER ##
#######################

# Windows 2019 Datacenter Domain Controller
resource "azurerm_windows_virtual_machine" "windows2019dc" {
  name                  = "BC-AD01"
  resource_group_name   = azurerm_resource_group.main.name
  location              = azurerm_resource_group.main.location
  size                  = var.azure-windows-vm-size
  admin_username        = var.windowsuser
  admin_password        = var.windows2019
  computer_name         = "BC-AD01"
  network_interface_ids = [azurerm_network_interface.dcwindows.id]

  os_disk {
    name                 = "dc-win-${random_id.randomId.hex}-os-disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = lookup(var.windows-2019-vm-image, "publisher", null)
    offer     = lookup(var.windows-2019-vm-image, "offer", null)
    sku       = lookup(var.windows-2019-vm-image, "sku", null)
    version   = lookup(var.windows-2019-vm-image, "version", null)
  }

  enable_automatic_updates = true
  provision_vm_agent       = true

  tags = var.tags
}

#################
## ADFS SERVER ##
#################

# Windows 2019 Datacenter Domain Controller
resource "azurerm_windows_virtual_machine" "windows2019adfs" {
  name                  = "BC-ADFS"
  resource_group_name   = azurerm_resource_group.main.name
  location              = azurerm_resource_group.main.location
  size                  = var.azure-windows-vm-size
  admin_username        = var.windowsuser
  admin_password        = var.windows2019
  computer_name         = "BC-ADFS"
  network_interface_ids = [azurerm_network_interface.adfswindows.id]

  os_disk {
    name                 = "adfs-win-${random_id.randomId.hex}-os-disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = lookup(var.windows-2019-vm-image, "publisher", null)
    offer     = lookup(var.windows-2019-vm-image, "offer", null)
    sku       = lookup(var.windows-2019-vm-image, "sku", null)
    version   = lookup(var.windows-2019-vm-image, "version", null)
  }

  enable_automatic_updates = true
  provision_vm_agent       = true

  tags = var.tags
}

##############################
## ACTIVE DIRECTORY CONNECT ##
##############################

# Windows 2019 Datacenter Domain Controller
resource "azurerm_windows_virtual_machine" "windows2019adconnect" {
  name                  = "BC-ADCT"
  resource_group_name   = azurerm_resource_group.main.name
  location              = azurerm_resource_group.main.location
  size                  = var.azure-windows-vm-size
  admin_username        = var.windowsuser
  admin_password        = var.windows2019
  computer_name         = "BC-ADCT"
  network_interface_ids = [azurerm_network_interface.adctwindows.id]

  os_disk {
    name                 = "adct-win-${random_id.randomId.hex}-os-disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = lookup(var.windows-2019-vm-image, "publisher", null)
    offer     = lookup(var.windows-2019-vm-image, "offer", null)
    sku       = lookup(var.windows-2019-vm-image, "sku", null)
    version   = lookup(var.windows-2019-vm-image, "version", null)
  }

  enable_automatic_updates = true
  provision_vm_agent       = true

  tags = var.tags
}

##################################
## WEB APPLICATION PROXY SERVER ##
##################################

# Windows 2019 Datacenter Domain Controller
resource "azurerm_windows_virtual_machine" "windowsWAP" {
  name                  = "BC-WAP"
  resource_group_name   = azurerm_resource_group.main.name
  location              = azurerm_resource_group.main.location
  size                  = var.azure-windows-vm-size
  admin_username        = var.windowsuser
  admin_password        = var.windows2019
  computer_name         = "BC-WAP"
  network_interface_ids = [azurerm_network_interface.wapwindows.id]

  os_disk {
    name                 = "wap-win-${random_id.randomId.hex}-os-disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = lookup(var.windows-2019-vm-image, "publisher", null)
    offer     = lookup(var.windows-2019-vm-image, "offer", null)
    sku       = lookup(var.windows-2019-vm-image, "sku", null)
    version   = lookup(var.windows-2019-vm-image, "version", null)
  }

  enable_automatic_updates = true
  provision_vm_agent       = true

  tags = var.tags
}

resource "azurerm_virtual_machine_extension" "chocoinstall" {
  depends_on = [azurerm_windows_virtual_machine.windowsWAP]
  name                 = "choco-install"
  virtual_machine_id   = azurerm_windows_virtual_machine.windowsWAP.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        "commandToExecute": "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"
    }
SETTINGS

  tags = var.tags
}

##############################
## WIN10 WORKSTATION SERVER ##
##############################

# Windows 2019 Datacenter Domain Controller
resource "azurerm_windows_virtual_machine" "windowsworkstation" {
  name                  = "BC-WIN10"
  resource_group_name   = azurerm_resource_group.main.name
  location              = azurerm_resource_group.main.location
  size                  = var.azure-windows-vm-size
  admin_username        = var.windowsuser
  admin_password        = var.windows2019
  computer_name         = "BC-WIN10"
  network_interface_ids = [azurerm_network_interface.workstationwindows.id]

  os_disk {
    name                 = "win-10-${random_id.randomId.hex}-os-disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = lookup(var.windows-10-vm-image, "publisher", null)
    offer     = lookup(var.windows-10-vm-image, "offer", null)
    sku       = lookup(var.windows-10-vm-image, "sku", null)
    version   = lookup(var.windows-10-vm-image, "version", null)
  }

  enable_automatic_updates = true
  provision_vm_agent       = true

  tags = var.tags
}

#############
## NETWORK ##
#############

# Windows Server Main Network Interface for ADFS Domain Controller
resource "azurerm_network_interface" "dcwindows" {
  name                = "dc-${var.adfs}-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  dns_servers = [ "10.0.0.4" ]

  ip_configuration {
    name                          = "domain-controller"
    subnet_id                     = azurerm_subnet.defaultSubnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.0.4"
  }
}

# Windows Server Main Network Interface for ADFS Server
resource "azurerm_network_interface" "adfswindows" {
  name                = "${var.adfs}-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  dns_servers = [ "10.0.0.4" ]

  ip_configuration {
    name                          = "adfs-server"
    subnet_id                     = azurerm_subnet.defaultSubnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.0.5"
  }
}

# Windows Server Main Network Interface for ADCT Server
resource "azurerm_network_interface" "adctwindows" {
  name                = "adct-${var.adfs}-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  dns_servers = [ "10.0.0.4" ]

  ip_configuration {
    name                          = "adct-server"
    subnet_id                     = azurerm_subnet.defaultSubnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.0.6"
  }
}

# Web Application Proxy Windows Server 
resource "azurerm_network_interface" "wapwindows" {
  name                = "wap-${var.adfs}-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  dns_servers = [ "10.0.0.4", "168.63.129.16" ]

  ip_configuration {
    name                          = "WAP"
    subnet_id                     = azurerm_subnet.DMZnetwork.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.1.4"
    public_ip_address_id          = azurerm_public_ip.wapwindowspip.id
  }
}

# Public IP Address Windows
resource "azurerm_public_ip" "wapwindowspip" {
  name                = "${var.adfs}-WAP-vm-ip"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Static"

  tags = var.tags
}

# Windows Client Workstation
resource "azurerm_network_interface" "workstationwindows" {
  name                = "WIN10-${var.adfs}-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  dns_servers = [ "10.0.0.4" ]

  ip_configuration {
    name                          = "workstation"
    subnet_id                     = azurerm_subnet.defaultSubnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.0.11"
  }
}

##############
## SECURITY ##
##############

# Windows Virtual Subnet Association Group
resource "azurerm_subnet_network_security_group_association" "windows" {
  depends_on                = [azurerm_network_security_group.windows]
  subnet_id                 = azurerm_subnet.defaultSubnet.id
  network_security_group_id = azurerm_network_security_group.windows.id
}

# Windows Virtual Subnet Network Security Group
resource "azurerm_network_security_group" "windows" {
  name                = "${var.prefix}-nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "allow-rdp"
    description                = "allow-rdp"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

    security_rule {
    name                       = "allow-https"
    description                = "allow-https"
    priority                   = 1020
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-http"
    description                = "allow-http"
    priority                   = 1010
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  tags = var.tags
}