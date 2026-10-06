output "namespace" {
  description = "Namespace where Argo CD is installed."
  value       = helm_release.this.namespace
}

output "url" {
  description = "URL of the Argo CD UI, null when the Ingress is disabled."
  value       = var.hostname != null ? "${local.scheme}://${var.hostname}" : null
}

output "initial_admin_secret" {
  description = "Secret holding the generated password of the admin user."
  value       = "argocd-initial-admin-secret"
}

output "chart_version" {
  description = "Installed chart version."
  value       = helm_release.this.version
}
