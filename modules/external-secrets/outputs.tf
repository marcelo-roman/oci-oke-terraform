output "namespace" {
  description = "Namespace where External Secrets Operator is installed."
  value       = helm_release.this.namespace
}

output "cluster_secret_store" {
  description = "Name of the ClusterSecretStore backed by OCI Vault, null when oci_vault is null."
  value       = var.oci_vault != null ? local.cluster_secret_store_name : null
}

output "chart_version" {
  description = "Installed chart version."
  value       = helm_release.this.version
}
