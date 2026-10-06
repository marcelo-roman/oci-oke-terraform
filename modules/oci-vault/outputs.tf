output "vault_id" {
  description = "OCID of the vault."
  value       = oci_kms_vault.this.id
}

output "key_id" {
  description = "OCID of the master encryption key used to create secrets."
  value       = oci_kms_key.this.id
}

output "dynamic_group_name" {
  description = "Name of the dynamic group that matches the nodes."
  value       = oci_identity_dynamic_group.nodes.name
}
