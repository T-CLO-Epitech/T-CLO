

# Create resource group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

# Azure Container Registry (optional)
resource "random_string" "acr_suffix" {
  length  = 6
  upper   = false
  special = false
}


resource "azurerm_container_registry" "main" {
  name                = substr(replace("${var.app_name}${random_string.acr_suffix.result}", "-", ""), 0, 50)
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "Basic"
  admin_enabled       = true
}
resource "azurerm_container_group" "multi_container" {
  name                = "${var.app_name}-multi-aci"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  ip_address_type     = "Public"
  dns_name_label      = "${var.dns_name_label}-multi"
  os_type             = "Linux"
  
  image_registry_credential {
    server   = "index.docker.io"
    username = var.dockerhub_username
    password = var.dockerhub_password
  }

  container {
    name   = "app"
    image  = "vicous/t-clo-app-prod:latest"
    cpu    = "1.0"
    memory = "1.0"

    ports {
      port     = 80
      protocol = "TCP"
    }

    environment_variables = {
      "DATABASE_HOST" = "localhost"
      "DATABASE_PORT" = "5432"
      "DATABASE_NAME" = "myapp"
      "DATABASE_USER" = "admin"
      "DATABASE_PASSWORD" = var.db_password
    }
  }

  container {
    name   = "db"
    image  = "postgres:13"
    cpu    = "1.0"
    memory = "1.0"

    ports {
      port     = 5432
      protocol = "TCP"
    }

    environment_variables = {
      "POSTGRES_DB" = "myapp"
      "POSTGRES_USER" = "admin"
      "POSTGRES_PASSWORD" = var.db_password
    }
  }
}