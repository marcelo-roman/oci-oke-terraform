variable "namespace" {
  description = "Namespace where Keycloak and its database are installed."
  type        = string
  default     = "keycloak"
}

variable "chart_version" {
  description = "Version of the codecentric/keycloakx chart."
  type        = string
  default     = "7.3.2"
}

variable "database_chart_version" {
  description = "Version of the cnpg/cluster chart that creates the PostgreSQL cluster. Requires the CloudNativePG operator."
  type        = string
  default     = "0.9.0"
}

variable "database_instances" {
  description = "Number of PostgreSQL instances."
  type        = number
  default     = 1
}

variable "database_storage_size" {
  description = "Size of each PostgreSQL volume. OCI block volumes start at 50Gi."
  type        = string
  default     = "50Gi"
}

variable "storage_class" {
  description = "StorageClass of the PostgreSQL volumes. Null uses the cluster default."
  type        = string
  default     = null
}

variable "replicas" {
  description = "Number of Keycloak pods."
  type        = number
  default     = 1
}

variable "admin_username" {
  description = "Username of the bootstrap administrator."
  type        = string
  default     = "admin"
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
