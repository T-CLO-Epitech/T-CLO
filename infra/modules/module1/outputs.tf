#Affiche les données de l'instance créée

output "public_ip_vm1" {
  value = azurerm_public_ip.pip_vm1.ip_address
}
output "public_ip_vm2" {
  value = azurerm_public_ip.pip_vm2.ip_address
}

output "vm1_id" {
  value = azurerm_linux_virtual_machine.vm1.id
}

output "vm2_id" {
  value = azurerm_linux_virtual_machine.vm2.id
}
