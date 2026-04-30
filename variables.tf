# Name of the Resource Group

variable "resource_group_name" {
  type    = string
  default = "myResourceGroup"
}

# Location 

variable "location" {
  type    = string
  default = "North Europe"
}

# Name of the Virtual Network

variable "vnet_name" {
  type    = string
  default = "vnet-linux-server"
}

# Address space for the Virtual Network

variable "vnet_address_space" {
  type    = list(string)
  default = ["192.168.0.0/16"]
}

# Name of subnet

variable "subnet_name" {
  type    = string
  default = "subnet-linux-server"
}

# Address prefix for the subnet

variable "subnet_address_prefixes" {
  type    = string
  default = "192.168.1.0/24"
}

# Bastion Subnet Name

variable "subnet_bastion_name" {
  type    = string
  default = "AzureBastionSubnet"
}


variable "subnet_bastion_prefix" {
  type    = string
  default = "192.168.2.0/26"
}

# Public IP 

variable "public_ip_bastion_name" {
  type    = string
  default = "public-ip-bastion"
}

variable "public_ip_bastion_allocation_method" {
  type    = string
  default = "Static"
}


variable "public_ip_bastion_sku" {
  type    = string
  default = "Standard"
}

variable "bastion_host_name" {
  type    = string
  default = "bastion-host"
}


variable "bastion_host_ip_configuration_name" {
  type    = string
  default = "bastion-host-ip-config"
}


# Tags

variable "environment" {
  type    = string
  default = "dev"
}

# Security group Name

variable "network_security_group_name" {
  type    = string
  default = "nsg-linux-server"
}

# Security group rule Allow SSH

variable "network_security_rule_ssh" {
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))

  default = [
    {
      name                       = "SSH"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    }
  ]
}

# Allow HTTP

variable "network_security_rule_http" {
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))

  default = [
    {
      name                       = "HTTP"
      priority                   = 101
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    }
  ]
}

# Variable for Deny All Inbound Traffic

variable "network_security_rule_deny_all" {
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))

  default = [
    {
      name                       = "DenyAllInbound"
      priority                   = 4096
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]
}

# Variable for NIC

variable "nic_linux_vm_name" {
  type    = string
  default = "nic-linux-server"
}

variable "nic_linux_vm_ip_configuration_name" {
  type    = string
  default = "ipconfig-linux-server"
}

variable "nic_linux_vm_private_ip_address_allocation" {
  type    = string
  default = "Dynamic"
}

# variable for Linux VM

variable "linux_vm_name" {
  type    = string
  default = "linux-vm"
}

variable "linux_vm_size" {
  type    = string
  default = "Standard_B1s"
}

variable "linux_vm_admin_username" {
  type    = string
  default = "azureuser"
}

variable "linux_vm_os_disk_caching" {
  type    = string
  default = "ReadWrite"
}

variable "linux_vm_os_disk_storage_account_type" {
  type    = string
  default = "Standard_LRS"
}

variable "linux_vm_image_publisher" {
  type    = string
  default = "Canonical"
}

variable "linux_vm_image_offer" {
  type    = string
  default = "UbuntuServer"
}

variable "linux_vm_image_sku" {
  type    = string
  default = "18.04-LTS"
}

variable "linux_vm_image_version" {
  type    = string
  default = "latest"
}