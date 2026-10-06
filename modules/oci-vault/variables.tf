variable "tenancy_id" {
  description = "OCID of the tenancy, where the dynamic group is created."
  type        = string
}

variable "compartment_id" {
  description = "OCID of the compartment that holds the vault and the cluster nodes."
  type        = string
}

variable "name" {
  description = "Prefix for the vault, key, dynamic group and policy names."
  type        = string
}

variable "allow_write" {
  description = "Whether the nodes may also create and update secrets, which PushSecret needs. False grants read-only access."
  type        = bool
  default     = false
}

variable "freeform_tags" {
  description = "Freeform tags applied to the vault and the key."
  type        = map(string)
  default     = {}
}
