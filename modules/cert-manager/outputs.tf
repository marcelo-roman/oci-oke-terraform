output "namespace" {
  description = "Namespace where cert-manager is installed."
  value       = helm_release.this.namespace
}

output "cluster_issuers" {
  description = "Names of the ClusterIssuers created, empty when acme_email is null."
  value       = var.acme_email != null ? keys(local.issuers) : []
}

output "chart_version" {
  description = "Installed chart version."
  value       = helm_release.this.version
}
