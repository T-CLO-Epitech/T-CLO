

# Create resource group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

# Azure Container Registry (optional)
resource "random_string" "acr_suffix" {
  length  = 10
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
  dns_name_label      = "${var.dns_name_label}-multi-test"
  os_type             = "Linux"
  depends_on = [
    azurerm_container_registry.main
  ]
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
      "DB_HOST" = "127.0.0.1"
      "DB_PORT" = "3306"
      "DB_DATABASE" = "myapp"
      "DB_USERNAME" = "admin"
      "DB_PASSWORD" = var.db_password
      "DB_CONNECTION" = "mysql"
      "APP_KEY" = "base64:DJYTvaRkEZ/YcQsX3TMpB0iCjgme2rhlIOus9A1hnj4="

    }
     commands = [
      "/bin/sh",
      "-c",
      <<EOT
      #!/bin/sh
      # Wait for MySQL to be ready
      until php -r "new PDO('mysql:host=127.0.0.1;dbname=myapp','admin','${var.db_password}');" >/dev/null 2>&1; do
          echo "Waiting for database..."
          sleep 2
      done
      # Run migrations
      php artisan migrate --force
      # Start Laravel
      php artisan serve --host=0.0.0.0 --port=80
      EOT
    ]
  }

  container {
    name   = "db"
    image  = "mysql:8.0"
    cpu    = "1.0"
    memory = "1.0"

    ports {
      port     = 3306
      protocol = "TCP"
    }

    environment_variables = {
      "MYSQL_DATABASE" = "myapp"
      "MYSQL_USER" = "admin"
      "MYSQL_PASSWORD" = var.db_password
      "MYSQL_ROOT_PASSWORD" = var.db_password
    }
  }
}