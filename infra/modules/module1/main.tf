locals {
  prefix = "${var.project_name}-${var.environment}"
}

resource "azurerm_availability_set" "avset" {
  name                = "${local.prefix}-avset"
  location            = var.location
  resource_group_name = var.resource_group_name
  managed             = true

  tags = {
    Project = var.project_name
    Env     = var.environment
  }
}


resource "azurerm_public_ip" "pip_vm1" {
  name                = "${local.prefix}-pip_vm1"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "nic_vm1" {
  name                = "${local.prefix}-nic_vm1"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip_vm1.id
  }
}

# Network Security Group
resource "azurerm_network_security_group" "nsg" {
  name                = "${local.prefix}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  security_rule {
    name                       = "allow-ssh-22"
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
    name                       = "allow-http-80"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-http-8081"
    priority                   = 110
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
  }
}

resource "azurerm_linux_virtual_machine" "vm2" {
  name                = "${local.prefix}-vm2"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username
  availability_set_id = azurerm_availability_set.avset.id
  network_interface_ids = [azurerm_network_interface.nic_vm2.id]

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
    name                 = "${local.prefix}-osdisk-vm2"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  tags = {
    Project = var.project_name
    Env     = var.environment
  }
}
# Associate NSG with NIC
resource "azurerm_network_interface_security_group_association" "nic_nsg" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_public_ip" "pip_vm2" {
  name                = "${local.prefix}-pip_vm2"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "nic_vm2" {
  name                = "${local.prefix}-nic_vm2"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip_vm2.id
  }
}

resource "azurerm_network_interface_backend_address_pool_association" "nic_lb_association_vm1" {
  count                   = var.backend_address_pool_id != null ? 1 : 0
  network_interface_id    = azurerm_network_interface.nic_vm1.id
  ip_configuration_name   = "ipconfig1"
  backend_address_pool_id = var.backend_address_pool_id
}

resource "azurerm_network_interface_backend_address_pool_association" "nic_lb_association_vm2" {
  count                   = var.backend_address_pool_id != null ? 1 : 0
  network_interface_id    = azurerm_network_interface.nic_vm2.id
  ip_configuration_name   = "ipconfig1"
  backend_address_pool_id = var.backend_address_pool_id
}

resource "azurerm_linux_virtual_machine" "vm1" {
  name                = "${local.prefix}-vm1"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username
  network_interface_ids = [azurerm_network_interface.nic_vm1.id]

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
    name                 = "${local.prefix}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  tags = {
    Project = var.project_name
    Env     = var.environment
  }
}

