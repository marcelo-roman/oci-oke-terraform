locals {
  ingress_enabled = var.hostname != null
  tls_enabled     = local.ingress_enabled && var.cluster_issuer != null

  ingress_annotations = local.tls_enabled ? { "cert-manager.io/cluster-issuer" = var.cluster_issuer } : {}

  values = {
    controller = {
      workflowNamespaces = var.workflow_namespaces
      resources = {
        requests = { cpu = "50m", memory = "64Mi" }
        limits   = { memory = "256Mi" }
      }
    }
    workflow = {
      serviceAccount = {
        create = true
      }
      rbac = {
        create = true
      }
    }
    server = {
      authModes = var.auth_modes
      resources = {
        requests = { cpu = "20m", memory = "64Mi" }
        limits   = { memory = "256Mi" }
      }
      ingress = {
        enabled          = local.ingress_enabled
        ingressClassName = var.ingress_class_name
        annotations      = local.ingress_annotations
        hosts            = local.ingress_enabled ? [var.hostname] : []
        tls = local.tls_enabled ? [{
          secretName = "argo-workflows-tls"
          hosts      = [var.hostname]
        }] : []
      }
    }
  }
}

resource "helm_release" "this" {
  name             = "argo-workflows"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-workflows"
  version          = var.chart_version
  namespace        = var.namespace
  create_namespace = true
  max_history      = 5
  wait             = true
  timeout          = 600

  values = concat([yamlencode(local.values)], var.values)
}
