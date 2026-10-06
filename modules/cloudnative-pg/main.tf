locals {
  values = {
    crds = {
      create = true
    }
    resources = {
      requests = { cpu = "50m", memory = "128Mi" }
      limits   = { memory = "512Mi" }
    }
  }
}

resource "helm_release" "this" {
  name             = "cloudnative-pg"
  repository       = "https://cloudnative-pg.github.io/charts"
  chart            = "cloudnative-pg"
  version          = var.chart_version
  namespace        = var.namespace
  create_namespace = true
  max_history      = 5
  wait             = true
  timeout          = 600

  values = concat([yamlencode(local.values)], var.values)
}
