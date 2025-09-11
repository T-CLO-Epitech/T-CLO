#Affiche les données des instances créées
output "public_ip" {
  value = module.vm.public_ip
}

output "vm_id" {
  value = module.vm.vm_id
}


# Generate Ansible inventory in the root folder
data "template_file" "ansible_inventory_dev" {
  template = file("${path.module}/inventory.ini.dev.tmpl")
  vars = {
    vm_ip          = module.vm.public_ip
    admin_username = var.admin_username
  }
}

data "template_file" "ansible_inventory_prod" {
  template = file("${path.module}/inventory.ini.prod.tmpl")
  vars = {
    vm_ip          = module.vm.public_ip
    admin_username = var.admin_username
  }
}

resource "local_file" "inventory_dev" {
  filename = "${path.module}/inventory_dev.ini"  # will create inventory.ini in root
  content  = data.template_file.ansible_inventory_dev.rendered
}
resource "local_file" "inventory_dev" {
  filename = "${path.module}/inventory_prod.ini"  # will create inventory.ini in root
  content  = data.template_file.ansible_inventory_prod.rendered
}