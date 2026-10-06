variable "compartment_id" {
  description = "OCID of the compartment where the cluster is created."
  type        = string
}

variable "name" {
  description = "Name of the cluster."
  type        = string
}

variable "vcn_id" {
  description = "OCID of the VCN that hosts the cluster."
  type        = string
}

variable "api_endpoint_subnet_id" {
  description = "OCID of the subnet that hosts the Kubernetes API endpoint."
  type        = string
}

variable "load_balancer_subnet_ids" {
  description = "OCIDs of the subnets where Services of type LoadBalancer are placed."
  type        = list(string)
}

variable "kubernetes_version" {
  description = "Kubernetes version such as v1.33.1. Null picks the newest version OKE offers."
  type        = string
  default     = null

  validation {
    condition     = var.kubernetes_version == null || can(regex("^v[0-9]+\\.[0-9]+\\.[0-9]+$", var.kubernetes_version))
    error_message = "kubernetes_version must look like v1.33.1."
  }
}

variable "cluster_type" {
  description = "BASIC_CLUSTER has a free control plane; ENHANCED_CLUSTER adds virtual nodes, add-ons and a financially backed SLA."
  type        = string
  default     = "BASIC_CLUSTER"

  validation {
    condition     = contains(["BASIC_CLUSTER", "ENHANCED_CLUSTER"], var.cluster_type)
    error_message = "cluster_type must be BASIC_CLUSTER or ENHANCED_CLUSTER."
  }
}

variable "is_public_endpoint" {
  description = "Whether the Kubernetes API endpoint gets a public IP."
  type        = bool
  default     = true
}

variable "pods_cidr" {
  description = "CIDR of the flannel overlay used by pods."
  type        = string
  default     = "10.244.0.0/16"
}

variable "services_cidr" {
  description = "CIDR used by Kubernetes Services."
  type        = string
  default     = "10.96.0.0/16"
}

variable "freeform_tags" {
  description = "Freeform tags applied to the cluster."
  type        = map(string)
  default     = {}
}
