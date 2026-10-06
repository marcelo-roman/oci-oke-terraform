data "oci_containerengine_cluster_option" "this" {
  cluster_option_id = "all"
  compartment_id    = var.compartment_id
}

locals {
  newest_kubernetes_version = reverse(sort(data.oci_containerengine_cluster_option.this.kubernetes_versions))[0]
  kubernetes_version        = coalesce(var.kubernetes_version, local.newest_kubernetes_version)
}

resource "oci_containerengine_cluster" "this" {
  compartment_id     = var.compartment_id
  vcn_id             = var.vcn_id
  name               = var.name
  kubernetes_version = local.kubernetes_version
  type               = var.cluster_type
  freeform_tags      = var.freeform_tags

  cluster_pod_network_options {
    cni_type = "FLANNEL_OVERLAY"
  }

  endpoint_config {
    subnet_id            = var.api_endpoint_subnet_id
    is_public_ip_enabled = var.is_public_endpoint
  }

  options {
    service_lb_subnet_ids = var.load_balancer_subnet_ids

    kubernetes_network_config {
      pods_cidr     = var.pods_cidr
      services_cidr = var.services_cidr
    }
  }
}
