output "public_ip" {
  value = module.vm.public_ip
}

output "vm_id" {
  value = module.vm.vm_id
}

# Generate Ansible inventory in the root folder
data "template_file" "ansible_inventory" {
  template = file("${path.module}/inventory.ini.tmpl")
  vars = {
    webserver_ip   = module.vm.public_ip["webserver"]
    database_ip    = module.vm.public_ip["database"]
    webserver2_ip     = module.vm.public_ip["webserver2"]
    admin_username = var.admin_username
  }
}

resource "local_file" "inventory" {
  filename = "${path.module}/inventory.ini"
  content  = data.template_file.ansible_inventory.rendered
}