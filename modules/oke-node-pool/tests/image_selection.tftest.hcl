mock_provider "oci" {
  mock_data "oci_identity_availability_domains" {
    defaults = {
      availability_domains = [
        { name = "AD-1" },
        { name = "AD-2" },
      ]
    }
  }

  mock_data "oci_containerengine_node_pool_option" {
    defaults = {
      sources = [
        { source_type = "IMAGE", image_id = "arm-gpu", source_name = "Oracle-Linux-9.8-Gen2-GPU-aarch64-2026.08.14-0-OKE-1.36.4-1820" },
        { source_type = "IMAGE", image_id = "arm-new", source_name = "Oracle-Linux-9.8-aarch64-2026.08.14-0-OKE-1.36.4-1820" },
        { source_type = "IMAGE", image_id = "arm-old", source_name = "Oracle-Linux-9.8-aarch64-2026.07.20-0-OKE-1.36.4-1578" },
        { source_type = "IMAGE", image_id = "x86-new", source_name = "Oracle-Linux-9.8-2026.08.14-0-OKE-1.36.4-1820" },
        { source_type = "IMAGE", image_id = "arm-prev", source_name = "Oracle-Linux-9.8-aarch64-2026.08.14-0-OKE-1.35.2-1820" },
      ]
    }
  }
}

variables {
  compartment_id     = "ocid1.compartment.oc1..test"
  cluster_id         = "ocid1.cluster.oc1..test"
  name               = "test"
  kubernetes_version = "v1.36.4"
  subnet_id          = "ocid1.subnet.oc1..test"
}

run "arm_shape_picks_newest_arm_image" {
  command = apply

  assert {
    condition     = output.image_id == "arm-new"
    error_message = "Expected the newest non-GPU aarch64 image for v1.36.4."
  }

  assert {
    condition     = length(oci_containerengine_node_pool.this.node_config_details[0].placement_configs) == 2
    error_message = "Expected one placement per availability domain."
  }

  assert {
    condition     = oci_containerengine_node_pool.this.node_shape_config[0].ocpus == 2
    error_message = "Expected the flexible shape config to be set."
  }
}

run "x86_shape_picks_x86_image" {
  command = plan

  variables {
    shape = "VM.Standard.E5.Flex"
  }

  assert {
    condition     = output.image_id == "x86-new"
    error_message = "Expected the x86 image for v1.36.4."
  }
}

run "fixed_shape_has_no_shape_config" {
  command = apply

  variables {
    shape = "VM.Standard2.1"
  }

  assert {
    condition     = length(oci_containerengine_node_pool.this.node_shape_config) == 0
    error_message = "Fixed shapes must not set node_shape_config."
  }
}

run "explicit_image_wins" {
  command = plan

  variables {
    image_id = "ocid1.image.oc1..explicit"
  }

  assert {
    condition     = output.image_id == "ocid1.image.oc1..explicit"
    error_message = "Expected the explicit image_id to be used."
  }
}

run "missing_image_fails" {
  command = plan

  variables {
    kubernetes_version = "v1.99.0"
  }

  expect_failures = [oci_containerengine_node_pool.this]
}
