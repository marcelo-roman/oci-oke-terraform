variable "namespace" {
  description = "Namespace where cert-manager is installed."
  type        = string
  default     = "cert-manager"
}

variable "chart_version" {
  description = "Version of the jetstack cert-manager chart."
  type        = string
  default     = "v1.21.2"
}

variable "acme_email" {
  description = "Email registered with Let's Encrypt. Null skips the creation of the ClusterIssuers."
  type        = string
  default     = null
}

variable "ingress_class_name" {
  description = "IngressClass used to solve HTTP-01 challenges."
  type        = string
  default     = "traefik"
}

variable "values" {
  description = "Extra YAML values applied after the module defaults."
  type        = list(string)
  default     = []
}
