locals {
  values = {
    crds = {
      enabled = true
    }
    resources = {
      requests = { cpu = "10m", memory = "64Mi" }
      limits   = { memory = "256Mi" }
    }
    webhook = {
      resources = {
        requests = { cpu = "10m", memory = "32Mi" }
        limits   = { memory = "128Mi" }
      }
    }
    cainjector = {
      resources = {
        requests = { cpu = "10m", memory = "64Mi" }
        limits   = { memory = "256Mi" }
      }
    }
  }

  issuers = {
    "letsencrypt-staging" = "https://acme-staging-v02.api.letsencrypt.org/directory"
    "letsencrypt-prod"    = "https://acme-v02.api.letsencrypt.org/directory"
  }
}

resource "helm_release" "this" {
  name             = "cert-manager"
  repository       = "oci://quay.io/jetstack/charts"
  chart            = "cert-manager"
  version          = var.chart_version
  namespace        = var.namespace
  create_namespace = true
  max_history      = 5
  wait             = true
  timeout          = 600

  values = concat([yamlencode(local.values)], var.values)
}

resource "helm_release" "cluster_issuers" {
  count = var.acme_email != null ? 1 : 0

  name        = "cluster-issuers"
  chart       = "${path.module}/charts/cluster-issuers"
  namespace   = var.namespace
  max_history = 5

  values = [yamlencode({
    email            = var.acme_email
    ingressClassName = var.ingress_class_name
    issuers          = local.issuers
  })]

  depends_on = [helm_release.this]
}
