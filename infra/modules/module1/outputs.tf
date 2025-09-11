output "public_ip" {
  description = "Adresses IP publiques par rôle (compatibilité)"
  value = {
    for role, pip in azurerm_public_ip.pip :
    role => pip.ip_address
  }
}

output "vm_id" {
  description = "IDs des VMs par rôle (compatibilité)"
  value = {
    for role, vm in azurerm_linux_virtual_machine.vm :
    role => vm.id
  }
}