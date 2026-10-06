locals {
  hostnames = var.domain == null ? {} : {
    argocd         = "argocd.${var.domain}"
    argo_workflows = "workflows.${var.domain}"
    keycloak       = "keycloak.${var.domain}"
    grafana        = "grafana.${var.domain}"
  }

  cluster_issuer = var.acme_email != null && var.addons.cert_manager ? var.cluster_issuer : null
}

module "traefik" {
  source = "../../modules/traefik"
  count  = var.addons.traefik ? 1 : 0
}

module "cert_manager" {
  source = "../../modules/cert-manager"
  count  = var.addons.cert_manager ? 1 : 0

  acme_email = var.acme_email
}

module "metrics_server" {
  source = "../../modules/metrics-server"
  count  = var.addons.metrics_server ? 1 : 0
}

module "external_secrets" {
  source = "../../modules/external-secrets"
  count  = var.addons.external_secrets ? 1 : 0

  oci_vault = var.oci_vault_id == null ? null : {
    vault_id = var.oci_vault_id
    region   = var.region
  }
}

module "cloudnative_pg" {
  source = "../../modules/cloudnative-pg"
  count  = var.addons.keycloak ? 1 : 0
}

module "argocd" {
  source = "../../modules/argocd"
  count  = var.addons.argocd ? 1 : 0

  hostname       = lookup(local.hostnames, "argocd", null)
  cluster_issuer = local.cluster_issuer

  depends_on = [module.traefik, module.cert_manager]
}

module "argo_rollouts" {
  source = "../../modules/argo-rollouts"
  count  = var.addons.argo_rollouts ? 1 : 0
}

module "argo_workflows" {
  source = "../../modules/argo-workflows"
  count  = var.addons.argo_workflows ? 1 : 0

  hostname       = lookup(local.hostnames, "argo_workflows", null)
  cluster_issuer = local.cluster_issuer

  depends_on = [module.traefik, module.cert_manager]
}

module "keycloak" {
  source = "../../modules/keycloak"
  count  = var.addons.keycloak ? 1 : 0

  hostname       = lookup(local.hostnames, "keycloak", null)
  cluster_issuer = local.cluster_issuer

  depends_on = [module.traefik, module.cert_manager, module.cloudnative_pg]
}

module "monitoring" {
  source = "../../modules/monitoring"
  count  = var.addons.monitoring ? 1 : 0

  hostname       = lookup(local.hostnames, "grafana", null)
  cluster_issuer = local.cluster_issuer

  depends_on = [module.traefik, module.cert_manager]
}
