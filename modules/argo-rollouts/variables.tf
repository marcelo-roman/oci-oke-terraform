variable "namespace" {
  description = "Namespace where Argo Rollouts is installed."
  type        = string
  default     = "argo-rollouts"
}

variable "chart_version" {
  description = "Version of the argo/argo-rollouts chart."
  type        = string
  default     = "2.43.6"
}

variable "dashboard_enabled" {
  description = "Whether the Rollouts dashboard is deployed. It has no authentication, so it is only reachable through kubectl port-forward."
  type        = bool
  default     = true
}

variable "values" {
  description = "Extra YAML values applied after the module defaults."
  type        = list(string)
  default     = []
}
