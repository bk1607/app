locals {
  dns_name = var.name == "frontend" ? "${var.env}.devops2023.online" : "${var.name}-${var.env}.devops2023.online"
  dns_word = var.env  == "prod"  ? "www" : var.env
}