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

variable "node_pools" {
  description = "Node pools keyed by name suffix. The default fills the Always Free A1 allowance of 4 OCPU and 24 GB."
  type = map(object({
    size          = optional(number, 2)
    shape         = optional(string, "VM.Standard.A1.Flex")
    ocpus         = optional(number, 2)
    memory_in_gbs = optional(number, 12)
  }))
  default = {
    arm = {}
  }
}

variable "tenancy_id" {
  description = "OCID of the tenancy. Required when vault_enabled is true."
  type        = string
  default     = null
}

variable "vault_enabled" {
  description = "Whether an OCI Vault is created and the nodes are allowed to read its secrets, for External Secrets Operator."
  type        = bool
  default     = false

  validation {
    condition     = !var.vault_enabled || var.tenancy_id != null
    error_message = "tenancy_id is required when vault_enabled is true."
  }
}
