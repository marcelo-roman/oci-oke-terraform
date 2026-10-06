locals {
  ingress_enabled = var.hostname != null
  tls_enabled     = local.ingress_enabled && var.cluster_issuer != null
  scheme          = local.tls_enabled ? "https" : "http"

  ingress_annotations = local.tls_enabled ? { "cert-manager.io/cluster-issuer" = var.cluster_issuer } : {}

  grafana_secret_name = "grafana-admin"

  prometheus_storage = var.prometheus_storage_size == null ? {} : {
    volumeClaimTemplate = {
      spec = merge(
        {
          accessModes = ["ReadWriteOnce"]
          resources   = { requests = { storage = var.prometheus_storage_size } }
        },
        var.storage_class != null ? { storageClassName = var.storage_class } : {},
      )
    }
  }

  values = {
    kubeEtcd = {
      enabled = !var.managed_control_plane
    }
    kubeScheduler = {
      enabled = !var.managed_control_plane
    }
    kubeControllerManager = {
      enabled = !var.managed_control_plane
    }
    kubeProxy = {
      enabled = !var.managed_control_plane
    }
    alertmanager = {
      enabled = var.alertmanager_enabled
      alertmanagerSpec = {
        resources = {
          requests = { cpu = "10m", memory = "32Mi" }
          limits   = { memory = "128Mi" }
        }
      }
    }
    prometheus = {
      prometheusSpec = {
        retention                               = var.prometheus_retention
        serviceMonitorSelectorNilUsesHelmValues = false
        podMonitorSelectorNilUsesHelmValues     = false
        ruleSelectorNilUsesHelmValues           = false
        storageSpec                             = local.prometheus_storage
        resources = {
          requests = { cpu = "100m", memory = "512Mi" }
          limits   = { memory = "2Gi" }
        }
      }
    }
    prometheusOperator = {
      resources = {
        requests = { cpu = "20m", memory = "64Mi" }
        limits   = { memory = "256Mi" }
      }
    }
    grafana = {
      admin = {
        existingSecret = local.grafana_secret_name
        userKey        = "admin-user"
        passwordKey    = "admin-password"
      }
      "grafana.ini" = {
        server = {
          root_url = local.ingress_enabled ? "${local.scheme}://${var.hostname}" : "http://localhost:3000"
        }
      }
      ingress = {
        enabled          = local.ingress_enabled
        ingressClassName = var.ingress_class_name
        annotations      = local.ingress_annotations
        hosts            = local.ingress_enabled ? [var.hostname] : []
        tls = local.tls_enabled ? [{
          secretName = "grafana-tls"
          hosts      = [var.hostname]
        }] : []
      }
      resources = {
        requests = { cpu = "50m", memory = "128Mi" }
        limits   = { memory = "512Mi" }
      }
    }
  }
}

resource "kubernetes_namespace_v1" "this" {
  metadata {
    name = var.namespace
  }
}

resource "random_password" "grafana_admin" {
  length  = 32
  special = false
}

resource "kubernetes_secret_v1" "grafana_admin" {
  metadata {
    name      = local.grafana_secret_name
    namespace = kubernetes_namespace_v1.this.metadata[0].name
  }

  data = {
    admin-user     = var.grafana_admin_username
    admin-password = random_password.grafana_admin.result
  }
}

resource "helm_release" "this" {
  name        = "kube-prometheus-stack"
  repository  = "https://prometheus-community.github.io/helm-charts"
  chart       = "kube-prometheus-stack"
  version     = var.chart_version
  namespace   = kubernetes_namespace_v1.this.metadata[0].name
  max_history = 5
  wait        = true
  timeout     = 900

  values = concat([yamlencode(local.values)], var.values)

  depends_on = [kubernetes_secret_v1.grafana_admin]
}
