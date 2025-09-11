terraform {
  backend "consul" {
    address = "37.59.113.68:8500"
    path    = "terraform/test-NT"
  }
}