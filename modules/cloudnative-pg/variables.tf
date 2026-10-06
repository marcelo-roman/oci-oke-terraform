variable "namespace" {
  description = "Namespace where the CloudNativePG operator is installed."
  type        = string
  default     = "cnpg-system"
}

variable "chart_version" {
  description = "Version of the cnpg/cloudnative-pg chart."
  type        = string
  default     = "0.29.1"
}

variable "values" {
  description = "Extra YAML values applied after the module defaults."
  type        = list(string)
  default     = []
}
