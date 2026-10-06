output "id" {
  description = "OCID of the node pool."
  value       = oci_containerengine_node_pool.this.id
}

output "image_id" {
  description = "OCID of the image the node pool was created with."
  value       = local.image_id
}

output "nodes" {
  description = "Name and private IP of every node in the pool."
  value = [
    for node in oci_containerengine_node_pool.this.nodes : {
      name       = node.name
      private_ip = node.private_ip
    }
  ]
}
