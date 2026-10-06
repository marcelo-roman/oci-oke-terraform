variable "region" {
  description = "OCI region identifier, e.g. sa-saopaulo-1."
  type        = string
}

variable "oci_profile" {
  description = "Profile from ~/.oci/config used to authenticate."
  type        = string
  default     = "DEFAULT"
}

variable "compartment_id" {
  description = "OCID of the compartment where the cluster is created."
  type        = string
}

variable "cluster_name" {
  description = "Name of the cluster."
  type        = string
  default     = "oke"
}

variable "kubernetes_version" {
  description = "Kubernetes version such as v1.33.1. Null picks the newest one."
  type        = string
  default     = null
}

variable "api_allowed_cidrs" {
  description = "CIDRs allowed to reach the Kubernetes API."
  type        = list(string)
}

variable "ssh_public_key" {
  description = "SSH public key installed on the nodes."
  type        = string
  default     = null
}
