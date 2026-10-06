output "cluster_id" {
  description = "OCID of the cluster."
  value       = module.cluster.id
}

output "kubernetes_version" {
  description = "Kubernetes version of the control plane."
  value       = module.cluster.kubernetes_version
}

output "api_public_endpoint" {
  description = "Public endpoint of the Kubernetes API."
  value       = module.cluster.public_endpoint
}

output "vcn_id" {
  description = "OCID of the VCN."
  value       = module.network.vcn_id
}

output "node_pools" {
  description = "OCID and nodes of every node pool."
  value = {
    for key, pool in module.node_pool : key => {
      id    = pool.id
      nodes = pool.nodes
    }
  }
}
