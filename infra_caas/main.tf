

# Create resource group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

# Azure Container Registry (optional)
resource "azurerm_container_registry" "main" {
  name                = replace("${var.app_name}acr", "-", "")
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
    ports {
      port     = 8081
      protocol = "TCP"
    }
    environment_variables = {
      APP_DEBUG    = "true"
      APP_ENV      = "dev"
      APP_KEY      = "base64:DJYTvaRkEZ/YcQsX3TMpB0iCjgme2rhlIOus9A1hnj4="
      DB_CONNECTION= "mysql"
      DB_HOST      = "127.0.0.1"
      DB_PORT      = "3306"
      DB_DATABASE  = "app_database"
      DB_USERNAME  = "app_user"
      DB_PASSWORD  = "app_password"
    }
    commands = [
      "sh", "-c",
      "until php -r 'new PDO(\"mysql:host=127.0.0.1;port=3306;dbname=app_database\", \"app_user\", \"app_password\");' 2>/dev/null; do echo 'Waiting for DB...'; sleep 2; done; php artisan migrate --force; exec apache2-foreground"
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
      MYSQL_DATABASE      = "app_database"
      MYSQL_USER          = "app_user"
      MYSQL_PASSWORD      = "app_password"
      MYSQL_ROOT_PASSWORD = "app_root_password"
      MYSQL_TCP_PORT      = "3306"
    }

    volume {
        name       = "db-data"
        mount_path = "/var/lib/mysql"
        read_only  = false
        empty_dir  = true
    }
    volume {
        name       = "mysql-init"
        mount_path = "/docker-entrypoint-initdb.d"
        read_only  = false
        empty_dir  = true
    }
  }



  tags = {
    Environment = var.environment
    Application = "${var.app_name}-multi"
  }
}