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
    webserver_ip   = module.vm.public_ip["webserver"]
    database_ip    = module.vm.public_ip["database"]
    webserver2_ip     = module.vm.public_ip["webserver2"]
    admin_username = var.admin_username
  }
}

data "template_file" "ansible_inventory_prod" {
  template = file("${path.module}/inventory.ini.prod.tmpl")
  vars = {
    webserver_ip   = module.vm.public_ip["webserver"]
    database_ip    = module.vm.public_ip["database"]
    webserver2_ip     = module.vm.public_ip["webserver2"]
    admin_username = var.admin_username
  }
}

resource "local_file" "inventory_dev" {
  filename = "${path.module}/inventory_dev.ini"
  content  = data.template_file.ansible_inventory_dev.rendered
}
resource "local_file" "inventory_prod" {
  filename = "${path.module}/inventory_prod.ini"
  content  = data.template_file.ansible_inventory_prod.rendered
}