
resource "azurerm_public_ip" "lb_pip" {
  name                = "${var.project_name}-${var.environment}-lb-pip"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}


resource "azurerm_lb" "lb" {
  name                = "${var.project_name}-${var.environment}-lb"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "frontend-ip"
    public_ip_address_id = azurerm_public_ip.lb_pip.id
  }
}


resource "azurerm_lb_backend_address_pool" "backend_pool" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "backend-pool"
}


resource "azurerm_lb_probe" "health_probe" {
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "health-probe"
  port                = 80
  protocol            = "Http"
  request_path        = "/"
  interval_in_seconds = 15
  number_of_probes    = 2
}


resource "azurerm_lb_rule" "lb_rule" {
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "lb-rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "frontend-ip"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backend_pool.id]
  probe_id                       = azurerm_lb_probe.health_probe.id
}

module "vm" {
  source           = "./modules/module1"

  project_name     = var.project_name
  environment      = var.environment
  location         = var.location
  vm_size          = var.vm_size
  admin_username   = var.admin_username
  ssh_public_key   = var.ssh_public_key
  allow_ssh_from_cidr = var.allow_ssh_from_cidr

  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.subnet.id
}
