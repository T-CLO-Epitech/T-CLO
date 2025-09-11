output "load_balancer_public_ip" {
  value       = azurerm_public_ip.lb_pip.ip_address
}

output "public_ip_vm1" {
  value       = module.vm.public_ip_vm1
}

output "public_ip_vm2" {
  value       = module.vm.public_ip_vm2
}

output "vm1_id" {
  value       = module.vm.vm1_id
}

output "vm2_id" {
  value       = module.vm.vm2_id
}

data "template_file" "ansible_inventory" {
  template = file("${path.module}/inventory.ini.tmpl")
  vars = {
    load_balancer_ip = azurerm_public_ip.lb_pip.ip_address
    vm1_private_ip   = module.vm.public_ip_vm1
    vm2_private_ip   = module.vm.public_ip_vm2
    admin_username   = var.admin_username
  }
}

resource "local_file" "inventory" {
  filename = "${path.module}/inventory.ini"
  content  = data.template_file.ansible_inventory.rendered
}