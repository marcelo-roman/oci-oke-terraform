output "namespace" {
  description = "Namespace where Argo Workflows is installed."
  value       = helm_release.this.namespace
}

output "url" {
  description = "URL of the Argo Workflows UI, null when the Ingress is disabled."
  value       = var.hostname != null ? "${local.tls_enabled ? "https" : "http"}://${var.hostname}" : null
}

output "chart_version" {
  description = "Installed chart version."
  value       = helm_release.this.version
}
