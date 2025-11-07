output "public_ip" {
  description = "Adresses IP publiques par rôle (compatibilité)"
  value = merge(
    { for role, pip in azurerm_public_ip.pip : role => pip.ip_address },
    { for role, pip in azurerm_public_ip.pip_database : role => pip.ip_address }
  )
}


output "vm_id" {
  description = "IDs des VMs par rôle (compatibilité)"
  value = merge(
    {for role, vm in azurerm_linux_virtual_machine.vm : role => vm.id},
    {for role, vm in azurerm_linux_virtual_machine.vm_database : role => vm.id}
  )
}
