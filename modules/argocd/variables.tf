variable "namespace" {
  description = "Namespace where Argo CD is installed."
  type        = string
  default     = "argocd"
}

variable "chart_version" {
  description = "Version of the argo/argo-cd chart."
  type        = string
  default     = "10.9.6"
}

variable "oidc" {
  description = "OpenID Connect provider used for SSO, e.g. a Keycloak realm. Null keeps only the local admin user."
  type = object({
    name          = optional(string, "Keycloak")
    issuer        = string
    client_id     = string
    client_secret = string
    scopes        = optional(list(string), ["openid", "profile", "email", "groups"])
  })
  default   = null
  sensitive = true
}

variable "hostname" {
  description = "Public hostname. Null disables the Ingress."
  type        = string
  default     = null
}

variable "ingress_class_name" {
  description = "IngressClass of the Ingress."
  type        = string
  default     = "traefik"
}

variable "cluster_issuer" {
  description = "cert-manager ClusterIssuer that signs the TLS certificate. Null serves the Ingress without TLS."
  type        = string
  default     = null
}

variable "values" {
  description = "Extra YAML values applied after the module defaults."
  type        = list(string)
  default     = []
}
