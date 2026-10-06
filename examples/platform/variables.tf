variable "region" {
  description = "OCI region of the cluster, e.g. sa-saopaulo-1."
  type        = string
}

variable "oci_profile" {
  description = "Profile from ~/.oci/config used to authenticate."
  type        = string
  default     = "DEFAULT"
}

variable "cluster_id" {
  description = "OCID of the OKE cluster, the cluster_id output of examples/always-free."
  type        = string
}

variable "domain" {
  description = "Base domain whose subdomains point to the Traefik load balancer, e.g. lab.example.com. Null disables every Ingress; reach the UIs with kubectl port-forward."
  type        = string
  default     = null
}

variable "acme_email" {
  description = "Email registered with Let's Encrypt. Null disables TLS on the Ingresses."
  type        = string
  default     = null
}

variable "cluster_issuer" {
  description = "ClusterIssuer used when acme_email is set: letsencrypt-staging while testing, letsencrypt-prod afterwards."
  type        = string
  default     = "letsencrypt-staging"

  validation {
    condition     = contains(["letsencrypt-staging", "letsencrypt-prod"], var.cluster_issuer)
    error_message = "cluster_issuer must be letsencrypt-staging or letsencrypt-prod."
  }
}

variable "oci_vault_id" {
  description = "OCID of the OCI Vault read by External Secrets Operator, the vault_id output of examples/always-free. Null installs the operator without a ClusterSecretStore."
  type        = string
  default     = null
}

variable "addons" {
  description = "Add-ons to install."
  type = object({
    traefik          = optional(bool, true)
    cert_manager     = optional(bool, true)
    metrics_server   = optional(bool, true)
    external_secrets = optional(bool, true)
    argocd           = optional(bool, true)
    argo_rollouts    = optional(bool, true)
    argo_workflows   = optional(bool, true)
    keycloak         = optional(bool, true)
    monitoring       = optional(bool, true)
  })
  default = {}
}
