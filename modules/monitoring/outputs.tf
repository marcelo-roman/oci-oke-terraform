output "namespace" {
  description = "Namespace where the monitoring stack is installed."
  value       = kubernetes_namespace_v1.this.metadata[0].name
}

output "grafana_url" {
  description = "URL of Grafana, null when the Ingress is disabled."
  value       = local.ingress_enabled ? "${local.scheme}://${var.hostname}" : null
}

output "grafana_admin_username" {
  description = "Username of the Grafana administrator."
  value       = var.grafana_admin_username
}

output "grafana_admin_password" {
  description = "Password of the Grafana administrator."
  value       = random_password.grafana_admin.result
  sensitive   = true
}

output "chart_version" {
  description = "Installed chart version."
  value       = helm_release.this.version
}
