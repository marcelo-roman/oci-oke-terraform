output "vcn_id" {
  description = "OCID of the VCN."
  value       = oci_core_vcn.this.id
}

output "api_endpoint_subnet_id" {
  description = "OCID of the subnet that hosts the Kubernetes API endpoint."
  value       = oci_core_subnet.api_endpoint.id
}

output "workers_subnet_id" {
  description = "OCID of the subnet that hosts the worker nodes."
  value       = oci_core_subnet.workers.id
}

output "load_balancers_subnet_id" {
  description = "OCID of the subnet that hosts the load balancers."
  value       = oci_core_subnet.load_balancers.id
}

output "nat_gateway_id" {
  description = "OCID of the NAT gateway used by the workers."
  value       = oci_core_nat_gateway.this.id
}
