# oci-vault

OCI Vault with a software-protected master key, plus the dynamic group and policy that let the cluster nodes read its secrets through their instance principal. Deleting a vault only schedules its deletion; OCI keeps it for 7 to 30 days.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| terraform | >= 1.7 |
| oci | >= 9.8, < 10.0 |

## Providers

| Name | Version |
| ---- | ------- |
| oci | >= 9.8, < 10.0 |

## Resources

| Name | Type |
| ---- | ---- |
| [oci_identity_dynamic_group.nodes](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_dynamic_group) | resource |
| [oci_identity_policy.nodes](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_policy) | resource |
| [oci_kms_key.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/kms_key) | resource |
| [oci_kms_vault.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/kms_vault) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| compartment\_id | OCID of the compartment that holds the vault and the cluster nodes. | `string` | n/a | yes |
| name | Prefix for the vault, key, dynamic group and policy names. | `string` | n/a | yes |
| tenancy\_id | OCID of the tenancy, where the dynamic group is created. | `string` | n/a | yes |
| allow\_write | Whether the nodes may also create and update secrets, which PushSecret needs. False grants read-only access. | `bool` | `false` | no |
| freeform\_tags | Freeform tags applied to the vault and the key. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| dynamic\_group\_name | Name of the dynamic group that matches the nodes. |
| key\_id | OCID of the master encryption key used to create secrets. |
| vault\_id | OCID of the vault. |
<!-- END_TF_DOCS -->
