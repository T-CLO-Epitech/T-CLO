locals {
  prefix = "${var.project_name}-${var.environment}"

  vms = {
    webserver = {
      name = "webserver"
      size = var.vm_size
      ports = ["22", "80", "443", "8080"]
      tags = {
        Role = "webserver"
        Tier = "frontend"
      }
    }
    database = {
      name = "database"
      size = var.vm_size
      ports = ["22", "3306"]
      tags = {
        Role = "database"
        Tier = "backend"
      }
    }
    webserver2 = {
      name = "webserver2"
      size = var.vm_size
      ports = ["22", "80", "443", "8080"]
      tags = {
        Role = "webserver2"
        Tier = "frontend"
      }
    }
  }
}

resource "azurerm_public_ip" "pip" {
  for_each            = local.vms
  name                = "${local.prefix}-${each.value.name}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = merge({
    Project = var.project_name
    Env     = var.environment
  }, each.value.tags)
}

resource "azurerm_network_interface" "nic" {
  for_each            = local.vms
  name                = "${local.prefix}-${each.value.name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip[each.key].id
  }

  tags = merge({
    Project = var.project_name
    Env     = var.environment
  }, each.value.tags)
}

resource "azurerm_network_security_group" "webserver_nsg" {
  name                = "${local.prefix}-webserver-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "allow-ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }


  security_rule {
    name                       = "allow-http"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }


  security_rule {
    name                       = "allow-https"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-app"
    priority                   = 130
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8081"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    Project = var.project_name
    Env     = var.environment
    Role    = "webserver"
  }
}

resource "azurerm_network_security_group" "database_nsg" {
  name                = "${local.prefix}-database-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "allow-ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-mysql"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3306"
    source_address_prefix      = "10.0.0.0/16"
    destination_address_prefix = "*"
  }

  tags = {
    Project = var.project_name
    Env     = var.environment
    Role    = "database"
  }
}

resource "azurerm_network_interface_security_group_association" "webserver_nic_nsg" {
  network_interface_id      = azurerm_network_interface.nic["webserver"].id
  network_security_group_id = azurerm_network_security_group.webserver_nsg.id
}

resource "azurerm_network_interface_security_group_association" "database_nic_nsg" {
  network_interface_id      = azurerm_network_interface.nic["database"].id
  network_security_group_id = azurerm_network_security_group.database_nsg.id
}

resource "azurerm_network_interface_security_group_association" "webserver2_nic_nsg" {
  network_interface_id      = azurerm_network_interface.nic["webserver2"].id
  network_security_group_id = azurerm_network_security_group.webserver_nsg.id
}

resource "azurerm_linux_virtual_machine" "vm" {
  for_each            = local.vms
  name                = "${local.prefix}-${each.value.name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = each.value.size
  admin_username      = var.admin_username
  network_interface_ids = [azurerm_network_interface.nic[each.key].id]

  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  source_image_reference {
    publisher = "Debian"
    offer     = "debian-12"
    sku       = "12"
    version   = "latest"
  }

  os_disk {
    name                 = "${local.prefix}-${each.value.name}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  tags = merge({
    Project = var.project_name
    Env     = var.environment
  }, each.value.tags)
}

output "vm_public_ips" {
  description = "Adresses IP publiques par rôle"
  value = {
    for role, vm in azurerm_public_ip.pip :
    role => vm.ip_address
  }
}

output "vm_private_ips" {
  description = "Adresses IP privées par rôle"
  value = {
    for role, nic in azurerm_network_interface.nic :
    role => nic.private_ip_address
  }
}

output "vm_names" {
  description = "Noms des VMs par rôle"
  value = {
    for role, vm in azurerm_linux_virtual_machine.vm :
    role => vm.name
  }
}

output "vm_ids" {
  description = "IDs des VMs par rôle"
  value = {
    for role, vm in azurerm_linux_virtual_machine.vm :
    role => vm.id
  }
}