

output "multi_container_group_fqdn" {
  description = "FQDN of the multi-container group"
  value       = azurerm_container_group.multi_container.fqdn
}

output "multi_container_group_ip_address" {
  description = "IP address of the multi-container group"
  value       = azurerm_container_group.multi_container.ip_address
}


output "acr_admin_password" {
  description = "ACR admin password"
  value       = azurerm_container_registry.main.admin_password
  sensitive   = true
}





output "multi_container_web_url" {
  description = "URL to access the web container in multi-container group"
  value       = "http://${azurerm_container_group.multi_container.fqdn}:80"
}

output "multi_container_api_url" {
  description = "URL to access the API container in multi-container group"
  value       = "http://${azurerm_container_group.multi_container.fqdn}:3000"
}

