# Terraform configuration for Azure infrastructure

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

# Provider configuration
provider "azurerm" {
  features {}
}


# Resource group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Virtual Network and Subnet

resource "azurerm_virtual_network" "vnet-linux-server" {
  name                = var.vnet_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = var.vnet_address_space


  tags = {
    environment = var.environment
  }

}


# Subnet 

resource "azurerm_subnet" "subnet-linux-server" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet-linux-server.name
  address_prefixes     = [var.subnet_address_prefixes]
}

# Bastion Private IP Address

resource "azurerm_subnet" "subnet-bastion" {
  name                 = var.subnet_bastion_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet-linux-server.name
  address_prefixes     = [var.subnet_bastion_prefix]
}

# Public IP for Bastion Host

resource "azurerm_public_ip" "public_ip_bastion" {
  name                = var.public_ip_bastion_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = var.public_ip_bastion_allocation_method
  sku                 = var.public_ip_bastion_sku

  tags = {
    environment = var.environment
  }
}


# Bastion Host

resource "azurerm_bastion_host" "bastion_host" {
  name                = var.bastion_host_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                 = var.bastion_host_ip_configuration_name
    subnet_id            = azurerm_subnet.subnet-bastion.id
    public_ip_address_id = azurerm_public_ip.public_ip_bastion.id
  }
}

# Security Group

resource "azurerm_network_security_group" "web-dev" {
  name                = var.network_security_group_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags = {
    environment = var.environment

  }
}

# Security Group Rule Allow HTTP

resource "azurerm_network_security_rule" "allow_http" {
  name                        = var.network_security_rule_http[0].name
  priority                    = var.network_security_rule_http[0].priority
  direction                   = var.network_security_rule_http[0].direction
  access                      = var.network_security_rule_http[0].access
  protocol                    = var.network_security_rule_http[0].protocol
  source_port_range           = var.network_security_rule_http[0].source_port_range
  destination_port_range      = var.network_security_rule_http[0].destination_port_range
  source_address_prefix       = var.network_security_rule_http[0].source_address_prefix
  destination_address_prefix  = var.network_security_rule_http[0].destination_address_prefix
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.web-dev.name
}

# Security Group Rule Allow SSH

resource "azurerm_network_security_rule" "allow_ssh" {
  name                        = var.network_security_rule_ssh[0].name
  priority                    = var.network_security_rule_ssh[0].priority
  direction                   = var.network_security_rule_ssh[0].direction
  access                      = var.network_security_rule_ssh[0].access
  protocol                    = var.network_security_rule_ssh[0].protocol
  source_port_range           = var.network_security_rule_ssh[0].source_port_range
  destination_port_range      = var.network_security_rule_ssh[0].destination_port_range
  source_address_prefix       = var.network_security_rule_ssh[0].source_address_prefix
  destination_address_prefix  = var.network_security_rule_ssh[0].destination_address_prefix
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.web-dev.name

}

# Deny All Inbound Traffic

resource "azurerm_network_security_rule" "deny_all_inbound" {
  name                        = var.network_security_rule_deny_all[0].name
  priority                    = var.network_security_rule_deny_all[0].priority
  direction                   = var.network_security_rule_deny_all[0].direction
  access                      = var.network_security_rule_deny_all[0].access
  protocol                    = var.network_security_rule_deny_all[0].protocol
  source_port_range           = var.network_security_rule_deny_all[0].source_port_range
  destination_port_range      = var.network_security_rule_deny_all[0].destination_port_range
  source_address_prefix       = var.network_security_rule_deny_all[0].source_address_prefix
  destination_address_prefix  = var.network_security_rule_deny_all[0].destination_address_prefix
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.web-dev.name

}


# Associate NSG to Subnet

resource "azurerm_subnet_network_security_group_association" "nsg_association" {
  subnet_id                 = azurerm_subnet.subnet-linux-server.id
  network_security_group_id = azurerm_network_security_group.web-dev.id
}


# Create NIC for Linux VM

resource "azurerm_network_interface" "nic_linux_vm" {
  name                = var.nic_linux_vm_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = var.nic_linux_vm_ip_configuration_name
    subnet_id                     = azurerm_subnet.subnet-linux-server.id
    private_ip_address_allocation = var.nic_linux_vm_private_ip_address_allocation
  }
}

# Create Linux VM

resource "azurerm_linux_virtual_machine" "linux_vm" {
  name                = var.linux_vm_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = var.linux_vm_size

  admin_username = var.linux_vm_admin_username

  network_interface_ids = [
    azurerm_network_interface.nic_linux_vm.id
  ]

  depends_on = [azurerm_network_interface.nic_linux_vm]

  admin_ssh_key {
    username   = var.linux_vm_admin_username
    public_key = file("C:\\Users\\omolo\\.ssh\\id_rsa.pub")
  }

  os_disk {
    caching              = var.linux_vm_os_disk_caching
    storage_account_type = var.linux_vm_os_disk_storage_account_type
  }

  source_image_reference {
    publisher = var.linux_vm_image_publisher
    offer     = var.linux_vm_image_offer
    sku       = var.linux_vm_image_sku
    version   = var.linux_vm_image_version
  }

  tags = {
    environment = var.environment
  }

  custom_data = filebase64("./cloud-init.sh")
}