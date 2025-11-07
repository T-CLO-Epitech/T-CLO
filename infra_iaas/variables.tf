# fichier de déclaration des variables terraform
variable "project_name"       { type = string }
variable "environment"        { type = string }
variable "location"           { type = string }
variable "vm_size"            { type = string }
variable "DB_location"        { type = string }
variable "admin_username"     { type = string }
variable "ssh_public_key"     { type = string }
variable "allow_ssh_from_cidr"{ type = string }
