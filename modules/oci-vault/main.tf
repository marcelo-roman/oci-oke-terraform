locals {
  read_statements = [
    "Allow dynamic-group ${oci_identity_dynamic_group.nodes.name} to read secret-bundles in compartment id ${var.compartment_id}",
    "Allow dynamic-group ${oci_identity_dynamic_group.nodes.name} to read secrets in compartment id ${var.compartment_id}",
  ]

  write_statements = [
    "Allow dynamic-group ${oci_identity_dynamic_group.nodes.name} to manage secret-family in compartment id ${var.compartment_id}",
    "Allow dynamic-group ${oci_identity_dynamic_group.nodes.name} to use keys in compartment id ${var.compartment_id}",
  ]
}

resource "oci_kms_vault" "this" {
  compartment_id = var.compartment_id
  display_name   = "${var.name}-vault"
  vault_type     = "DEFAULT"
  freeform_tags  = var.freeform_tags
}

resource "oci_kms_key" "this" {
  compartment_id      = var.compartment_id
  display_name        = "${var.name}-secrets"
  management_endpoint = oci_kms_vault.this.management_endpoint
  protection_mode     = "SOFTWARE"
  freeform_tags       = var.freeform_tags

  key_shape {
    algorithm = "AES"
    length    = 32
  }
}

resource "oci_identity_dynamic_group" "nodes" {
  compartment_id = var.tenancy_id
  name           = "${var.name}-nodes"
  description    = "Instances of ${var.name} allowed to read OCI Vault secrets"
  matching_rule  = "ALL {instance.compartment.id = '${var.compartment_id}'}"
}

resource "oci_identity_policy" "nodes" {
  compartment_id = var.compartment_id
  name           = "${var.name}-vault-access"
  description    = "Lets the nodes of ${var.name} read secrets from OCI Vault"
  statements     = var.allow_write ? concat(local.read_statements, local.write_statements) : local.read_statements
}
