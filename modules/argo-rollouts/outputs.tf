output "namespace" {
  description = "Namespace where Argo Rollouts is installed."
  value       = helm_release.this.namespace
}

output "dashboard_command" {
  description = "Command that exposes the dashboard on localhost:3100, null when the dashboard is disabled."
  value       = var.dashboard_enabled ? "kubectl -n ${helm_release.this.namespace} port-forward svc/argo-rollouts-dashboard 3100:3100" : null
}

output "chart_version" {
  description = "Installed chart version."
  value       = helm_release.this.version
}
