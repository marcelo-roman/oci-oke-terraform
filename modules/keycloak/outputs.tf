output "namespace" {
  description = "Namespace where Keycloak is installed."
  value       = kubernetes_namespace_v1.this.metadata[0].name
}

output "url" {
  description = "URL of Keycloak, null when the Ingress is disabled."
  value       = local.ingress_enabled ? "${local.scheme}://${var.hostname}" : null
}

output "admin_username" {
  description = "Username of the bootstrap administrator."
  value       = var.admin_username
}

output "admin_password" {
  description = "Password of the bootstrap administrator."
  value       = random_password.admin.result
  sensitive   = true
}

output "database_secret" {
  description = "Secret with the PostgreSQL credentials created by CloudNativePG."
  value       = local.database_secret
}

output "chart_version" {
  description = "Installed chart version."
  value       = helm_release.this.version
}
