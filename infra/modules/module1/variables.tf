# Fichier de variables pour le module1
variable "project_name"        { type = string }
variable "environment"         { type = string }
variable "location"            { type = string }
variable "vm_size"             { type = string }
variable "DB_location"         { type = string }
variable "admin_username"      { type = string }
variable "ssh_public_key"      { type = string }
variable "allow_ssh_from_cidr" { type = string }
variable "resource_group_name" { type = string }
variable "subnet_id"           { type = string }
variable "db_subnet_id"        { type = string }
variable "create_lb_outbound_rule" {
  type    = bool
  default = false
}