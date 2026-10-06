locals {
  cluster_secret_store_name = "oci-vault"

  small_resources = {
    requests = { cpu = "10m", memory = "32Mi" }
    limits   = { memory = "128Mi" }
  }

  values = {
    installCRDs = true
    resources = {
      requests = { cpu = "20m", memory = "64Mi" }
      limits   = { memory = "256Mi" }
    }
    webhook = {
      resources = local.small_resources
    }
    certController = {
      resources = local.small_resources
    }
  }
}

resource "helm_release" "this" {
  name             = "external-secrets"
  repository       = "https://charts.external-secrets.io"
  chart            = "external-secrets"
  version          = var.chart_version
  namespace        = var.namespace
  create_namespace = true
  max_history      = 5
  wait             = true
  timeout          = 600

  values = concat([yamlencode(local.values)], var.values)
}

resource "helm_release" "cluster_secret_store" {
  count = var.oci_vault != null ? 1 : 0

  name        = "cluster-secret-store"
  chart       = "${path.module}/charts/cluster-secret-store"
  namespace   = var.namespace
  max_history = 5

  values = [yamlencode({
    name          = local.cluster_secret_store_name
    vault         = var.oci_vault.vault_id
    region        = var.oci_vault.region
    compartment   = var.oci_vault.compartment_id
    encryptionKey = var.oci_vault.key_id
  })]

  depends_on = [helm_release.this]
}
