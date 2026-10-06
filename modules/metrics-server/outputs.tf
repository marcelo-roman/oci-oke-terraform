output "namespace" {
  description = "Namespace where metrics-server is installed."
  value       = helm_release.this.namespace
}

output "chart_version" {
  description = "Installed chart version."
  value       = helm_release.this.version
}
