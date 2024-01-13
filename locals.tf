locals {
  dns_name = var.name == "frontend" ? "${var.env}" : "${var.name}-${var.env}"
  dns_word = var.env  == "prod"  ? "www" : var.env
}