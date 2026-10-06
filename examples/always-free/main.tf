module "oke" {
  source = "../.."

  compartment_id     = var.compartment_id
  cluster_name       = var.cluster_name
  kubernetes_version = var.kubernetes_version
  api_allowed_cidrs  = var.api_allowed_cidrs
  ssh_public_key     = var.ssh_public_key

  node_pools = var.node_pools

  freeform_tags = {
    environment = "lab"
  }
}

module "vault" {
  source = "../../modules/oci-vault"
  count  = var.vault_enabled ? 1 : 0

  tenancy_id     = var.tenancy_id
  compartment_id = var.compartment_id
  name           = var.cluster_name

  freeform_tags = {
    environment = "lab"
  }
}
