mock_provider "oci" {
  mock_data "oci_core_services" {
    defaults = {
      services = [
        { id = "ocid1.service.oc1..all", cidr_block = "all-gru-services-in-oracle-services-network" },
      ]
    }
  }

  mock_data "oci_containerengine_cluster_option" {
    defaults = {
      kubernetes_versions = ["v1.35.2", "v1.36.4", "v1.36.1"]
    }
  }

  mock_data "oci_identity_availability_domains" {
    defaults = {
      availability_domains = [{ name = "AD-1" }]
    }
  }
}

variables {
  compartment_id    = "ocid1.compartment.oc1..test"
  api_allowed_cidrs = ["203.0.113.10/32"]
  node_pools        = {}
}

run "defaults_to_newest_kubernetes_version" {
  command = plan

  assert {
    condition     = module.cluster.kubernetes_version == "v1.36.4"
    error_message = "Expected the newest version offered by OKE."
  }
}

run "rejects_invalid_cluster_name" {
  command = plan

  variables {
    cluster_name = "My_Cluster"
  }

  expect_failures = [var.cluster_name]
}

run "rejects_invalid_api_cidr" {
  command = plan

  variables {
    api_allowed_cidrs = ["not-a-cidr"]
  }

  expect_failures = [var.api_allowed_cidrs]
}

run "rejects_unknown_cluster_type" {
  command = plan

  variables {
    cluster_type = "PREMIUM"
  }

  expect_failures = [var.cluster_type]
}
