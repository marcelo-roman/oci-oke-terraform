locals {
  ingress_enabled = var.hostname != null
  tls_enabled     = local.ingress_enabled && var.cluster_issuer != null
  scheme          = local.tls_enabled ? "https" : "http"

  ingress_annotations = local.tls_enabled ? { "cert-manager.io/cluster-issuer" = var.cluster_issuer } : {}

  database_name     = "keycloak"
  database_cluster  = "keycloak-db"
  database_secret   = "${local.database_cluster}-app"
  admin_secret_name = "keycloak-admin"

  hostname_env = local.ingress_enabled ? [{ name = "KC_HOSTNAME", value = "${local.scheme}://${var.hostname}" }] : []

  extra_env = concat([
    { name = "KC_HTTP_ENABLED", value = "true" },
    { name = "KC_PROXY_HEADERS", value = "xforwarded" },
    { name = "KC_HOSTNAME_STRICT", value = "false" },
    { name = "KC_HEALTH_ENABLED", value = "true" },
    { name = "KC_METRICS_ENABLED", value = "true" },
    {
      name      = "KC_BOOTSTRAP_ADMIN_USERNAME"
      valueFrom = { secretKeyRef = { name = local.admin_secret_name, key = "username" } }
    },
    {
      name      = "KC_BOOTSTRAP_ADMIN_PASSWORD"
      valueFrom = { secretKeyRef = { name = local.admin_secret_name, key = "password" } }
    },
  ], local.hostname_env)

  database_values = {
    fullnameOverride = local.database_cluster
    type             = "postgresql"
    mode             = "standalone"
    cluster = {
      instances = var.database_instances
      storage = {
        size         = var.database_storage_size
        storageClass = var.storage_class != null ? var.storage_class : ""
      }
      initdb = {
        database = local.database_name
        owner    = local.database_name
      }
      resources = {
        requests = { cpu = "50m", memory = "256Mi" }
        limits   = { memory = "1Gi" }
      }
    }
  }

  values = {
    replicas = var.replicas
    command  = ["/opt/keycloak/bin/kc.sh", "start", "--http-port=8080"]
    http = {
      relativePath = "/"
    }
    extraEnv = yamlencode(local.extra_env)
    database = {
      vendor            = "postgres"
      hostname          = "${local.database_cluster}-rw"
      port              = 5432
      database          = local.database_name
      username          = local.database_name
      existingSecret    = local.database_secret
      existingSecretKey = "password"
    }
    resources = {
      requests = { cpu = "100m", memory = "512Mi" }
      limits   = { memory = "1536Mi" }
    }
    ingress = {
      enabled          = local.ingress_enabled
      ingressClassName = var.ingress_class_name
      annotations      = local.ingress_annotations
      rules = [{
        host  = coalesce(var.hostname, "keycloak.local")
        paths = [{ path = "/", pathType = "Prefix" }]
      }]
      tls = local.tls_enabled ? [{
        secretName = "keycloak-tls"
        hosts      = [var.hostname]
      }] : []
    }
  }
}

resource "kubernetes_namespace_v1" "this" {
  metadata {
    name = var.namespace
  }
}

resource "random_password" "admin" {
  length  = 32
  special = false
}

resource "kubernetes_secret_v1" "admin" {
  metadata {
    name      = local.admin_secret_name
    namespace = kubernetes_namespace_v1.this.metadata[0].name
  }

  data = {
    username = var.admin_username
    password = random_password.admin.result
  }
}

resource "helm_release" "database" {
  name        = local.database_cluster
  repository  = "https://cloudnative-pg.github.io/charts"
  chart       = "cluster"
  version     = var.database_chart_version
  namespace   = kubernetes_namespace_v1.this.metadata[0].name
  max_history = 5
  wait        = true
  timeout     = 900

  values = [yamlencode(local.database_values)]
}

resource "helm_release" "this" {
  name        = "keycloak"
  repository  = "https://codecentric.github.io/helm-charts"
  chart       = "keycloakx"
  version     = var.chart_version
  namespace   = kubernetes_namespace_v1.this.metadata[0].name
  max_history = 5
  wait        = true
  timeout     = 900

  values = concat([yamlencode(local.values)], var.values)

  depends_on = [helm_release.database, kubernetes_secret_v1.admin]
}
