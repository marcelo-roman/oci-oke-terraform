locals {
  ingress_enabled = var.hostname != null
  tls_enabled     = local.ingress_enabled && var.cluster_issuer != null
  scheme          = local.tls_enabled ? "https" : "http"

  ingress_annotations = local.tls_enabled ? { "cert-manager.io/cluster-issuer" = var.cluster_issuer } : {}

  oidc_config = var.oidc == null ? {} : {
    "oidc.config" = yamlencode({
      name            = var.oidc.name
      issuer          = var.oidc.issuer
      clientID        = var.oidc.client_id
      clientSecret    = "$oidc.clientSecret"
      requestedScopes = var.oidc.scopes
    })
  }

  oidc_secret = var.oidc == null ? {} : {
    "oidc.clientSecret" = var.oidc.client_secret
  }

  values = {
    global = {
      domain = coalesce(var.hostname, "argocd.local")
    }
    configs = {
      params = {
        "server.insecure" = local.ingress_enabled
      }
      cm = merge(
        { url = "${local.scheme}://${coalesce(var.hostname, "argocd.local")}" },
        local.oidc_config,
      )
      secret = {
        extra = local.oidc_secret
      }
    }
    dex = {
      enabled = false
    }
    server = {
      ingress = {
        enabled          = local.ingress_enabled
        ingressClassName = var.ingress_class_name
        annotations      = local.ingress_annotations
        tls              = local.tls_enabled
      }
      resources = {
        requests = { cpu = "50m", memory = "128Mi" }
        limits   = { memory = "512Mi" }
      }
    }
    controller = {
      resources = {
        requests = { cpu = "100m", memory = "256Mi" }
        limits   = { memory = "1Gi" }
      }
    }
    repoServer = {
      resources = {
        requests = { cpu = "50m", memory = "128Mi" }
        limits   = { memory = "512Mi" }
      }
    }
    applicationSet = {
      resources = {
        requests = { cpu = "10m", memory = "64Mi" }
        limits   = { memory = "256Mi" }
      }
    }
    notifications = {
      resources = {
        requests = { cpu = "10m", memory = "32Mi" }
        limits   = { memory = "128Mi" }
      }
    }
    redis = {
      resources = {
        requests = { cpu = "10m", memory = "32Mi" }
        limits   = { memory = "128Mi" }
      }
    }
  }
}

resource "helm_release" "this" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = var.chart_version
  namespace        = var.namespace
  create_namespace = true
  max_history      = 5
  wait             = true
  timeout          = 900

  values = concat([yamlencode(local.values)], var.values)
}
