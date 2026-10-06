variable "namespace" {
  description = "Namespace where Argo Workflows is installed."
  type        = string
  default     = "argo"
}

variable "chart_version" {
  description = "Version of the argo/argo-workflows chart."
  type        = string
  default     = "2.0.11"
}

variable "workflow_namespaces" {
  description = "Namespaces where workflows run; each gets the service account the workflow pods use."
  type        = list(string)
  default     = ["argo"]
}

variable "auth_modes" {
  description = "Authentication modes of the Argo Server. 'client' requires a Kubernetes bearer token; 'server' grants everyone the server's permissions and must not be exposed."
  type        = list(string)
  default     = ["client"]

  validation {
    condition     = alltrue([for mode in var.auth_modes : contains(["client", "server", "sso"], mode)])
    error_message = "auth_modes accepts client, server and sso."
  }
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
