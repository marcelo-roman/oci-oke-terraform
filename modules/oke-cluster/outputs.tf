output "id" {
  description = "OCID of the cluster."
  value       = oci_containerengine_cluster.this.id
}

output "kubernetes_version" {
  description = "Kubernetes version of the control plane."
  value       = oci_containerengine_cluster.this.kubernetes_version
}

output "public_endpoint" {
  description = "Public endpoint of the Kubernetes API, empty when the endpoint is private."
  value       = oci_containerengine_cluster.this.endpoints[0].public_endpoint
}

output "private_endpoint" {
  description = "Private endpoint of the Kubernetes API."
  value       = oci_containerengine_cluster.this.endpoints[0].private_endpoint
}
