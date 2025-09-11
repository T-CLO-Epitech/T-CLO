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