variable "compartment_id" {
  description = "OCID of the compartment where the node pool is created."
  type        = string
}

variable "cluster_id" {
  description = "OCID of the cluster that owns the node pool."
  type        = string
}

variable "name" {
  description = "Name of the node pool."
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version of the nodes. Must not be newer than the control plane."
  type        = string
}

variable "subnet_id" {
  description = "OCID of the subnet where the nodes are placed."
  type        = string
}

variable "availability_domains" {
  description = "Availability domains the nodes are spread across. Null uses every domain of the region."
  type        = list(string)
  default     = null
}

variable "size" {
  description = "Number of nodes."
  type        = number
  default     = 2

  validation {
    condition     = var.size >= 0
    error_message = "size must be zero or greater."
  }
}

variable "shape" {
  description = "Compute shape of the nodes."
  type        = string
  default     = "VM.Standard.A1.Flex"
}

variable "ocpus" {
  description = "OCPUs per node. Only applies to flexible shapes."
  type        = number
  default     = 2
}

variable "memory_in_gbs" {
  description = "Memory in GB per node. Only applies to flexible shapes."
  type        = number
  default     = 12
}

variable "boot_volume_size_in_gbs" {
  description = "Boot volume size in GB per node."
  type        = number
  default     = 50

  validation {
    condition     = var.boot_volume_size_in_gbs >= 50
    error_message = "boot_volume_size_in_gbs must be at least 50."
  }
}

variable "is_pv_encryption_in_transit_enabled" {
  description = "Whether traffic between the nodes and their boot volumes is encrypted."
  type        = bool
  default     = true
}

variable "image_id" {
  description = "OCID of the node image. Null picks the newest OKE image matching the Kubernetes version and the shape architecture."
  type        = string
  default     = null
}

variable "ssh_public_key" {
  description = "SSH public key installed on the nodes. Null disables SSH key injection."
  type        = string
  default     = null
}

variable "node_labels" {
  description = "Kubernetes labels applied to the nodes."
  type        = map(string)
  default     = {}
}

variable "freeform_tags" {
  description = "Freeform tags applied to the node pool and its nodes."
  type        = map(string)
  default     = {}
}
