variable "namespace" {
  description = "Namespace where metrics-server is installed."
  type        = string
  default     = "kube-system"
}

variable "chart_version" {
  description = "Version of the metrics-server chart."
  type        = string
  default     = "3.14.0"
}

variable "kubelet_insecure_tls" {
  description = "Skip verification of the kubelet serving certificates. Needed on clusters whose kubelets use self-signed certificates."
  type        = bool
  default     = false
}

variable "values" {
  description = "Extra YAML values applied after the module defaults."
  type        = list(string)
  default     = []
}
