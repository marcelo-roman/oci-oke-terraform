variable "namespace" {
  description = "Namespace where Traefik is installed."
  type        = string
  default     = "traefik"
}

variable "chart_version" {
  description = "Version of the traefik/traefik chart."
  type        = string
  default     = "41.6.1"
}

variable "replicas" {
  description = "Number of Traefik pods."
  type        = number
  default     = 1
}

variable "is_default_ingress_class" {
  description = "Whether the traefik IngressClass is the cluster default."
  type        = bool
  default     = true
}

variable "redirect_to_https" {
  description = "Whether plain HTTP requests are redirected to HTTPS."
  type        = bool
  default     = true
}

variable "load_balancer_bandwidth_mbps" {
  description = "Bandwidth of the OCI flexible load balancer. 10 Mbps is the Always Free shape."
  type        = number
  default     = 10
}

variable "service_annotations" {
  description = "Extra annotations merged into the LoadBalancer Service, overriding the OCI defaults."
  type        = map(string)
  default     = {}
}

variable "values" {
  description = "Extra YAML values applied after the module defaults."
  type        = list(string)
  default     = []
}
