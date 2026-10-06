locals {
  values = {
    args = var.kubelet_insecure_tls ? ["--kubelet-insecure-tls"] : []
    resources = {
      requests = { cpu = "50m", memory = "64Mi" }
      limits   = { memory = "256Mi" }
    }
  }
}

resource "helm_release" "this" {
  name        = "metrics-server"
  repository  = "https://kubernetes-sigs.github.io/metrics-server/"
  chart       = "metrics-server"
  version     = var.chart_version
  namespace   = var.namespace
  max_history = 5
  wait        = true
  timeout     = 600

  values = concat([yamlencode(local.values)], var.values)
}
