locals {
  oci_load_balancer_annotations = {
    "oci.oraclecloud.com/load-balancer-type"                      = "lb"
    "service.beta.kubernetes.io/oci-load-balancer-shape"          = "flexible"
    "service.beta.kubernetes.io/oci-load-balancer-shape-flex-min" = tostring(var.load_balancer_bandwidth_mbps)
    "service.beta.kubernetes.io/oci-load-balancer-shape-flex-max" = tostring(var.load_balancer_bandwidth_mbps)
  }

  https_redirect = {
    entryPoint = {
      to        = "websecure"
      scheme    = "https"
      permanent = true
    }
  }

  values = {
    deployment = {
      replicas = var.replicas
    }
    ingressClass = {
      enabled        = true
      isDefaultClass = var.is_default_ingress_class
    }
    providers = {
      kubernetesIngress = {
        publishedService = {
          enabled = true
        }
      }
    }
    service = {
      type        = "LoadBalancer"
      annotations = merge(local.oci_load_balancer_annotations, var.service_annotations)
    }
    ports = {
      web = {
        http = {
          redirections = var.redirect_to_https ? local.https_redirect : {}
        }
      }
    }
    resources = {
      requests = { cpu = "50m", memory = "64Mi" }
      limits   = { memory = "256Mi" }
    }
  }
}

resource "helm_release" "this" {
  name             = "traefik"
  repository       = "https://traefik.github.io/charts"
  chart            = "traefik"
  version          = var.chart_version
  namespace        = var.namespace
  create_namespace = true
  max_history      = 5
  wait             = true
  timeout          = 600

  values = concat([yamlencode(local.values)], var.values)
}
