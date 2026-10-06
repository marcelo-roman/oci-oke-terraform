variable "compartment_id" {
  description = "OCID of the compartment where every resource is created."
  type        = string
}

variable "cluster_name" {
  description = "Name of the cluster, also used as prefix for the network resources."
  type        = string
  default     = "oke"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{0,30}$", var.cluster_name))
    error_message = "cluster_name must start with a letter and contain only lowercase letters, digits and hyphens, up to 31 characters."
  }
}

variable "kubernetes_version" {
  description = "Kubernetes version such as v1.33.1. Null picks the newest version OKE offers; pin it to control upgrades."
  type        = string
  default     = null
}

variable "cluster_type" {
  description = "BASIC_CLUSTER (free control plane) or ENHANCED_CLUSTER."
  type        = string
  default     = "BASIC_CLUSTER"

  validation {
    condition     = contains(["BASIC_CLUSTER", "ENHANCED_CLUSTER"], var.cluster_type)
    error_message = "cluster_type must be BASIC_CLUSTER or ENHANCED_CLUSTER."
  }
}

variable "network" {
  description = "CIDR blocks of the VCN, its subnets, the pod overlay and the Services."
  type = object({
    vcn_cidr                   = optional(string, "10.0.0.0/16")
    api_endpoint_subnet_cidr   = optional(string, "10.0.0.0/28")
    workers_subnet_cidr        = optional(string, "10.0.10.0/24")
    load_balancers_subnet_cidr = optional(string, "10.0.20.0/24")
    pods_cidr                  = optional(string, "10.244.0.0/16")
    services_cidr              = optional(string, "10.96.0.0/16")
  })
  default = {}
}

variable "api_allowed_cidrs" {
  description = "CIDRs allowed to reach the Kubernetes API on port 6443."
  type        = list(string)

  validation {
    condition     = alltrue([for cidr in var.api_allowed_cidrs : can(cidrhost(cidr, 0))])
    error_message = "Every entry of api_allowed_cidrs must be a valid IPv4 CIDR block."
  }
}

variable "load_balancer_allowed_cidrs" {
  description = "CIDRs allowed to reach the load balancers on ports 80 and 443."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "node_pools" {
  description = "Node pools keyed by name suffix. The defaults fill the Always Free A1 allowance: 2 nodes x 2 OCPU x 12 GB."
  type = map(object({
    size                    = optional(number, 2)
    shape                   = optional(string, "VM.Standard.A1.Flex")
    ocpus                   = optional(number, 2)
    memory_in_gbs           = optional(number, 12)
    boot_volume_size_in_gbs = optional(number, 50)
    image_id                = optional(string)
    node_labels             = optional(map(string), {})
  }))
  default = {
    default = {}
  }
}

variable "ssh_public_key" {
  description = "SSH public key installed on every node. Null disables SSH key injection."
  type        = string
  default     = null
}

variable "freeform_tags" {
  description = "Freeform tags applied to every resource."
  type        = map(string)
  default     = {}
}
