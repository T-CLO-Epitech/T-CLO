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
  Database = {
    database = {
      name = "database"
      size = var.vm_size
      ports = ["22", "3306"]
      tags = {
        Role = "database"
        Tier = "backend"
      }
    }
  }
  lb_vms = {
    for k, v in local.vms : k => v
    if contains(["webserver", "webserver2"], k)
  }
}


resource "azurerm_public_ip" "lb_pip" {
  name                = "${local.prefix}-lb-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    Project = var.project_name
    Env     = var.environment
    Role    = "loadbalancer"
  }
}
resource "azurerm_lb" "main" {
  name                = "${local.prefix}-lb"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb_pip.id
  }

  tags = {
    Project = var.project_name
    Env     = var.environment
    Role    = "loadbalancer"
  }
}

# Health Probe HTTP
resource "azurerm_lb_probe" "http" {
  loadbalancer_id = azurerm_lb.main.id
  name            = "http-probe"
  protocol        = "Http"
  port            = 80
  request_path    = "/"
}

# Health Probe HTTPS
resource "azurerm_lb_probe" "https" {
  loadbalancer_id = azurerm_lb.main.id
  name            = "https-probe"
  protocol        = "Tcp"
  port            = 443
}

# Load Balancer Rule - HTTP
resource "azurerm_lb_rule" "http" {
  loadbalancer_id                = azurerm_lb.main.id
  name                           = "http-rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.main.id]
  probe_id                       = azurerm_lb_probe.http.id
  disable_outbound_snat          = true
}

# Load Balancer Rule - HTTPS
resource "azurerm_lb_rule" "https" {
  loadbalancer_id                = azurerm_lb.main.id
  name                           = "https-rule"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.main.id]
  probe_id                       = azurerm_lb_probe.https.id
  disable_outbound_snat          = true
}

# Load Balancer Rule - Custom App Port
resource "azurerm_lb_rule" "app" {
  loadbalancer_id                = azurerm_lb.main.id
  name                           = "app-rule"
  protocol                       = "Tcp"
  frontend_port                  = 8081
  backend_port                   = 8081
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.main.id]
  disable_outbound_snat          = true
}

# Outbound Rule pour la connectivité sortante
resource "azurerm_lb_outbound_rule" "main" {
  count                   = var.create_lb_outbound_rule ? 1 : 0

  name                    = "outbound-rule"
  loadbalancer_id         = azurerm_lb.main.id
  protocol                = "All"
  backend_address_pool_id = azurerm_lb_backend_address_pool.main.id

  frontend_ip_configuration {
    name = "PublicIPAddress"
  }
}

resource "azurerm_lb_backend_address_pool" "main" {
  loadbalancer_id = azurerm_lb.main.id
  name            = "${local.prefix}-backend-pool"
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
resource "azurerm_public_ip" "pip_database" {
  for_each = local.Database
  name                = "${local.prefix}-${each.value.name}-pip"
  location            = var.DB_location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
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

resource "azurerm_network_interface" "nic_database" {
  for_each            = local.Database
  name                = "${local.prefix}-${each.value.name}-nic"
  location            = var.DB_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = var.db_subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip_database[each.key].id
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
  location            = var.DB_location
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
  network_interface_id      = azurerm_network_interface.nic_database["database"].id
  network_security_group_id = azurerm_network_security_group.database_nsg.id
}

resource "azurerm_network_interface_security_group_association" "webserver2_nic_nsg" {
  network_interface_id      = azurerm_network_interface.nic["webserver2"].id
  network_security_group_id = azurerm_network_security_group.webserver_nsg.id
}

resource "azurerm_network_interface_backend_address_pool_association" "lb_assoc" {
  for_each = local.lb_vms

  network_interface_id    = azurerm_network_interface.nic[each.key].id
  ip_configuration_name   = "ipconfig1"
  backend_address_pool_id = azurerm_lb_backend_address_pool.main.id
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

resource "azurerm_linux_virtual_machine" "vm_database" {
  for_each            = local.Database
  name                = "${local.prefix}-${each.value.name}"
  resource_group_name = var.resource_group_name
  location            = var.DB_location
  size                = each.value.size
  admin_username      = var.admin_username
  network_interface_ids = [azurerm_network_interface.nic_database[each.key].id]
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
  description = "IP publiques par rôle"
  value = merge(
    { for role, pip in azurerm_public_ip.pip : role => pip.ip_address },
    { for role, pip in azurerm_public_ip.pip_database : role => pip.ip_address }
  )
}

output "vm_private_ips" {
  description = "IP privées par rôle"
  value = merge(
    { for role, nic in azurerm_network_interface.nic : role => nic.private_ip_address },
    { for role, nic in azurerm_network_interface.nic_database : role => nic.private_ip_address }
  )
}

output "vm_names" {
  description = "Noms des VMs par rôle"
  value = merge(
    { for role, vm in azurerm_linux_virtual_machine.vm : role => vm.name },
    { for role, vm in azurerm_linux_virtual_machine.vm_database : role => vm.name }
  )
}

output "vm_ids" {
  description = "IDs des VMs par rôle"
  value = merge(
    { for role, vm in azurerm_linux_virtual_machine.vm : role => vm.id },
    { for role, vm in azurerm_linux_virtual_machine.vm_database : role => vm.id }
  )
}

output "lb_public_ip" {
  description = "Adresse IP publique du Load Balancer"
  value       = azurerm_public_ip.lb_pip.ip_address
}

output "lb_id" {
  description = "ID du Load Balancer"
  value       = azurerm_lb.main.id
}

output "lb_frontend_ip_config" {
  description = "Configuration IP frontend du Load Balancer"
  value       = azurerm_lb.main.frontend_ip_configuration
}