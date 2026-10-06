locals {
  freeform_tags = merge({ cluster = var.cluster_name }, var.freeform_tags)
}

module "network" {
  source = "./modules/network"

  compartment_id              = var.compartment_id
  name                        = var.cluster_name
  vcn_cidr                    = var.network.vcn_cidr
  api_endpoint_subnet_cidr    = var.network.api_endpoint_subnet_cidr
  workers_subnet_cidr         = var.network.workers_subnet_cidr
  load_balancers_subnet_cidr  = var.network.load_balancers_subnet_cidr
  api_allowed_cidrs           = var.api_allowed_cidrs
  load_balancer_allowed_cidrs = var.load_balancer_allowed_cidrs
  freeform_tags               = local.freeform_tags
}

module "cluster" {
  source = "./modules/oke-cluster"

  compartment_id           = var.compartment_id
  name                     = var.cluster_name
  kubernetes_version       = var.kubernetes_version
  cluster_type             = var.cluster_type
  vcn_id                   = module.network.vcn_id
  api_endpoint_subnet_id   = module.network.api_endpoint_subnet_id
  load_balancer_subnet_ids = [module.network.load_balancers_subnet_id]
  pods_cidr                = var.network.pods_cidr
  services_cidr            = var.network.services_cidr
  freeform_tags            = local.freeform_tags
}

module "node_pool" {
  source   = "./modules/oke-node-pool"
  for_each = var.node_pools

  compartment_id          = var.compartment_id
  cluster_id              = module.cluster.id
  name                    = "${var.cluster_name}-${each.key}"
  kubernetes_version      = module.cluster.kubernetes_version
  subnet_id               = module.network.workers_subnet_id
  size                    = each.value.size
  shape                   = each.value.shape
  ocpus                   = each.value.ocpus
  memory_in_gbs           = each.value.memory_in_gbs
  boot_volume_size_in_gbs = each.value.boot_volume_size_in_gbs
  image_id                = each.value.image_id
  ssh_public_key          = var.ssh_public_key
  node_labels             = merge({ pool = each.key }, each.value.node_labels)
  freeform_tags           = local.freeform_tags
}
