variable "compartment_id" {
  description = "OCID of the compartment where the network is created."
  type        = string
}

variable "name" {
  description = "Prefix for the display name of every network resource."
  type        = string
}

variable "vcn_cidr" {
  description = "CIDR block of the VCN."
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrhost(var.vcn_cidr, 0))
    error_message = "vcn_cidr must be a valid IPv4 CIDR block."
  }
}

variable "api_endpoint_subnet_cidr" {
  description = "CIDR of the public subnet that hosts the Kubernetes API endpoint."
  type        = string
  default     = "10.0.0.0/28"
}

variable "workers_subnet_cidr" {
  description = "CIDR of the private subnet that hosts the worker nodes."
  type        = string
  default     = "10.0.10.0/24"
}

variable "load_balancers_subnet_cidr" {
  description = "CIDR of the public subnet that hosts the load balancers created by Services."
  type        = string
  default     = "10.0.20.0/24"
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

variable "freeform_tags" {
  description = "Freeform tags applied to every resource."
  type        = map(string)
  default     = {}
}
