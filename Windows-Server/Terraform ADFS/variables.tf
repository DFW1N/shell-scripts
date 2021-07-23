# Name Prefix for Resources
variable "prefix" {
  type        = string
  description = "The prefix which should be used for all resources in this deployment"
  default     = "adfs-training"
}

# Name Prefix for Resources
variable "adfs" {
  type        = string
  description = "The prefix which should be used for all resources in this deployment"
  default     = "adfs"
}

# Location Variable
variable "location" {
  type        = string
  description = "The Azure Region in which all resources in this deployment should be created."
  default     = "australiaeast"
}

## Administrator Windows Username Variable
variable "windowsuser" {
  description = "The windows username for this deployment."
  default     = "adminuser"
}

# Administrator Password Variable
variable "windows2019" {
  description = "The password for windows 2019 server on this deployment."
  default     = "YOURAMAZINGPASSWORD"
}

# Windows web VM Virtual Machine Size
variable "azure-windows-vm-size" {
  type        = string
  description = "Windows Server VM Size"
  default     = "Standard_A1_v2"
}

variable "tags" {
  description = "A map of the tags to use for the resources that are deployed"
  type        = map(string)

  default = {
    environment = "adfs-training"
  }
}

variable "windows-2019-vm-image" {
  type        = map(string)
  description = "Windows 2019 virtual machine source image information"
  default = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

variable "windows-10-vm-image" {
  type        = map(string)
  description = "Windows 10 Enterprise virtual machine source image information"
  default = {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-10"
    sku       = "21h1-ent"
    version   = "latest"
  }
}
