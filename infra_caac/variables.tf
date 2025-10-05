variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "my-app-rg"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
}

variable "app_name" {
  description = "Name of the application"
  type        = string
  default     = "my-docker-app"
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "container_image" {
  description = "Docker image to deploy"
  type        = string
  default     = "nginx:alpine"
}

variable "container_port" {
  description = "Container port to expose"
  type        = number
  default     = 80
}

variable "cpu" {
  description = "CPU cores"
  type        = number
  default     = 1
}

variable "memory" {
  description = "Memory in GB"
  type        = number
  default     = 2
}

variable "dns_name_label" {
  description = "DNS label for the container group"
  type        = string
  default     = "myapp"
}

variable "dockerhub_username" {
  description = "Docker Hub username for image pull authentication"
  type        = string
}

variable "dockerhub_password" {
  description = "Docker Hub access token or password"
  type        = string
  sensitive   = true
}