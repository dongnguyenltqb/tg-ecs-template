module "irsa" {
  source                    = "../irsa"
  role_name                 = format("%sAppOnCluster%sRole", var.app_name, var.cluster_name)
  service_account_name      = "pg14"
  service_account_namespace = "pg14"
  cluster_oidc_url          = var.cluster_oidc_url
  cluster_oidc_arn          = var.cluster_oidc_arn
  custom_policy_documents   = var.custom_policy_documents
  managed_policy_arns       = var.managed_policy_arns
  tags                      = var.tags
}

resource "kubernetes_namespace" "pg14" {
  depends_on = [
    module.irsa
  ]
  metadata {
    annotations = {
      name = "pg14"
    }

    labels = {
      name = "pg14"
    }

    name = "pg14"
  }
}

resource "kubernetes_service_account" "pg14" {
  metadata {
    name      = "pg14"
    namespace = kubernetes_namespace.pg14.id
    annotations = {
      "eks.amazonaws.com/role-arn" = module.irsa.role_arn
      "createdBy"                  = "terragrunt"
    }
  }
}


resource "kubernetes_pod" "master" {
  depends_on = [
    module.irsa
  ]
  metadata {
    name      = "pg14"
    namespace = kubernetes_namespace.pg14.id
  }
  spec {
    service_account_name = kubernetes_service_account.pg14.metadata[0].name
    container {
      image = "nginx:1.21.6"
      name  = "pg"
      port {
        container_port = 5432
      }
    }
  }
}

