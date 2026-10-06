variable "namespace" {
  description = "Namespace where the monitoring stack is installed."
  type        = string
  default     = "monitoring"
}

variable "chart_version" {
  description = "Version of the prometheus-community/kube-prometheus-stack chart."
  type        = string
  default     = "91.9.0"
}

variable "prometheus_retention" {
  description = "How long Prometheus keeps samples."
  type        = string
  default     = "3d"
}

variable "prometheus_storage_size" {
  description = "Size of the Prometheus volume. Null keeps data on an emptyDir that is lost when the pod restarts; OCI block volumes start at 50Gi."
  type        = string
  default     = null
}

variable "storage_class" {
  description = "StorageClass of the Prometheus volume. Null uses the cluster default."
  type        = string
  default     = null
}

variable "alertmanager_enabled" {
  description = "Whether Alertmanager is deployed."
  type        = bool
  default     = true
}

variable "grafana_admin_username" {
  description = "Username of the Grafana administrator."
  type        = string
  default     = "admin"
}

variable "managed_control_plane" {
  description = "Whether the control plane is managed by the cloud provider, which hides etcd, the scheduler and the controller manager from scraping."
  type        = bool
  default     = true
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
