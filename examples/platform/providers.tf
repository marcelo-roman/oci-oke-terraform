provider "oci" {
  region              = var.region
  config_file_profile = var.oci_profile
}

data "oci_containerengine_cluster_kube_config" "this" {
  cluster_id    = var.cluster_id
  token_version = "2.0.0"
  endpoint      = "PUBLIC_ENDPOINT"
}

locals {
  kubeconfig = yamldecode(data.oci_containerengine_cluster_kube_config.this.content)
  cluster    = local.kubeconfig.clusters[0].cluster

  exec_args = [
    "ce", "cluster", "generate-token",
    "--cluster-id", var.cluster_id,
    "--region", var.region,
    "--profile", var.oci_profile,
  ]
}

provider "kubernetes" {
  host                   = local.cluster.server
  cluster_ca_certificate = base64decode(local.cluster["certificate-authority-data"])

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "oci"
    args        = local.exec_args
  }
}

provider "helm" {
  kubernetes = {
    host                   = local.cluster.server
    cluster_ca_certificate = base64decode(local.cluster["certificate-authority-data"])

    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "oci"
      args        = local.exec_args
    }
  }
}
