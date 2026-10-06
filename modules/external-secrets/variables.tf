variable "namespace" {
  description = "Namespace where External Secrets Operator is installed."
  type        = string
  default     = "external-secrets"
}

variable "chart_version" {
  description = "Version of the external-secrets/external-secrets chart."
  type        = string
  default     = "2.12.0"
}

variable "oci_vault" {
  description = "OCI Vault exposed as the ClusterSecretStore 'oci-vault', read with the instance principal of the nodes. Null installs only the operator."
  type = object({
    vault_id       = string
    region         = string
    compartment_id = optional(string)
    key_id         = optional(string)
  })
  default = null
}

variable "values" {
  description = "Extra YAML values applied after the module defaults."
  type        = list(string)
  default     = []
}
