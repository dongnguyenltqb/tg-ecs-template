module "backend-secret" {
  source       = "../../terraform-modules/secret-manager"
  tags         = var.tags
  secret_name  = var.secret_name
  secret_value = var.secret_value
}
