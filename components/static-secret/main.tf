module "this" {
  source       = "../../terraform-modules/secret-manager"
  tags         = var.tags
  secret_name  = var.static_secret_name
  secret_value = var.static_secret_value
}
