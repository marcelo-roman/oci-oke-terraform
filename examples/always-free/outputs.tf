output "cluster_id" {
  description = "OCID of the cluster."
  value       = module.oke.cluster_id
}

output "kubernetes_version" {
  description = "Kubernetes version of the control plane."
  value       = module.oke.kubernetes_version
}

output "api_public_endpoint" {
  description = "Public endpoint of the Kubernetes API."
  value       = module.oke.api_public_endpoint
}

output "node_pools" {
  description = "OCID and nodes of every node pool."
  value       = module.oke.node_pools
}

output "kubeconfig_command" {
  description = "Command that writes the cluster credentials to ~/.kube/config."
  value       = "oci ce cluster create-kubeconfig --cluster-id ${module.oke.cluster_id} --region ${var.region} --profile ${var.oci_profile} --file $HOME/.kube/config --token-version 2.0.0 --kube-endpoint PUBLIC_ENDPOINT"
}

output "vault_id" {
  description = "OCID of the OCI Vault, null when vault_enabled is false."
  value       = try(module.vault[0].vault_id, null)
}

output "vault_key_id" {
  description = "OCID of the master encryption key, null when vault_enabled is false."
  value       = try(module.vault[0].key_id, null)
}
