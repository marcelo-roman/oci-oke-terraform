# external-secrets

External Secrets Operator and, when `oci_vault` is set, the `oci-vault` ClusterSecretStore that reads OCI Vault with the instance principal of the nodes. Pair it with the `oci-vault` module, which grants the nodes access.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| terraform | >= 1.7 |
| helm | >= 3.0, < 4.0 |

## Providers

| Name | Version |
| ---- | ------- |
| helm | >= 3.0, < 4.0 |

## Resources

| Name | Type |
| ---- | ---- |
| [helm_release.cluster_secret_store](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.this](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| chart\_version | Version of the external-secrets/external-secrets chart. | `string` | `"2.12.0"` | no |
| namespace | Namespace where External Secrets Operator is installed. | `string` | `"external-secrets"` | no |
| oci\_vault | OCI Vault exposed as the ClusterSecretStore 'oci-vault', read with the instance principal of the nodes. Null installs only the operator. | ```object({ vault_id = string region = string compartment_id = optional(string) key_id = optional(string) })``` | `null` | no |
| values | Extra YAML values applied after the module defaults. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| chart\_version | Installed chart version. |
| cluster\_secret\_store | Name of the ClusterSecretStore backed by OCI Vault, null when oci\_vault is null. |
| namespace | Namespace where External Secrets Operator is installed. |
<!-- END_TF_DOCS -->
