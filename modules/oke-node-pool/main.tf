data "oci_identity_availability_domains" "this" {
  compartment_id = var.compartment_id
}

data "oci_containerengine_node_pool_option" "this" {
  node_pool_option_id = var.cluster_id
  compartment_id      = var.compartment_id
}

locals {
  is_arm_shape  = length(regexall("\\.A[0-9]+\\.", var.shape)) > 0
  is_flex_shape = endswith(var.shape, ".Flex")
  image_arch    = local.is_arm_shape ? "aarch64" : "x86_64"
  image_suffix  = "OKE-${trimprefix(var.kubernetes_version, "v")}"

  matching_images = [
    for source in data.oci_containerengine_node_pool_option.this.sources : source
    if source.source_type == "IMAGE"
    && strcontains(source.source_name, local.image_suffix)
    && strcontains(source.source_name, "aarch64") == local.is_arm_shape
    && !strcontains(source.source_name, "GPU")
  ]

  image_id = var.image_id != null ? var.image_id : try(local.matching_images[0].image_id, null)

  availability_domains = (
    var.availability_domains != null
    ? var.availability_domains
    : data.oci_identity_availability_domains.this.availability_domains[*].name
  )
}

resource "oci_containerengine_node_pool" "this" {
  compartment_id     = var.compartment_id
  cluster_id         = var.cluster_id
  name               = var.name
  kubernetes_version = var.kubernetes_version
  node_shape         = var.shape
  ssh_public_key     = var.ssh_public_key
  freeform_tags      = var.freeform_tags

  dynamic "node_shape_config" {
    for_each = local.is_flex_shape ? [1] : []

    content {
      ocpus         = var.ocpus
      memory_in_gbs = var.memory_in_gbs
    }
  }

  node_source_details {
    source_type             = "IMAGE"
    image_id                = local.image_id
    boot_volume_size_in_gbs = var.boot_volume_size_in_gbs
  }

  node_config_details {
    size                                = var.size
    is_pv_encryption_in_transit_enabled = var.is_pv_encryption_in_transit_enabled
    freeform_tags                       = var.freeform_tags

    dynamic "placement_configs" {
      for_each = local.availability_domains

      content {
        availability_domain = placement_configs.value
        subnet_id           = var.subnet_id
      }
    }
  }

  dynamic "initial_node_labels" {
    for_each = var.node_labels

    content {
      key   = initial_node_labels.key
      value = initial_node_labels.value
    }
  }

  lifecycle {
    ignore_changes = [node_source_details[0].image_id]

    precondition {
      condition     = local.image_id != null
      error_message = "No OKE image matches ${var.kubernetes_version} on ${local.image_arch}; set image_id explicitly."
    }
  }
}
