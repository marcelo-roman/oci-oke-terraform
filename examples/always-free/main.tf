module "oke" {
  source = "../.."

  compartment_id     = var.compartment_id
  cluster_name       = var.cluster_name
  kubernetes_version = var.kubernetes_version
  api_allowed_cidrs  = var.api_allowed_cidrs
  ssh_public_key     = var.ssh_public_key

  node_pools = {
    arm = {
      size          = 2
      shape         = "VM.Standard.A1.Flex"
      ocpus         = 2
      memory_in_gbs = 12
    }
  }

  freeform_tags = {
    environment = "lab"
  }
}
