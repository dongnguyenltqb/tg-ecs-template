module "certificate" {
  source                  = "../../terraform-modules/cert-manager"
  hosted_zone_domain_name = var.hosted_zone_domain_name
  domain_name             = var.domain_name
  tags                    = var.tags
}
