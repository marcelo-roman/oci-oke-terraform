# cloudnative-pg

CloudNativePG operator, used by the keycloak module to run PostgreSQL.

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
| [helm_release.this](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| chart\_version | Version of the cnpg/cloudnative-pg chart. | `string` | `"0.29.1"` | no |
| namespace | Namespace where the CloudNativePG operator is installed. | `string` | `"cnpg-system"` | no |
| values | Extra YAML values applied after the module defaults. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| chart\_version | Installed chart version. |
| namespace | Namespace where the operator is installed. |
<!-- END_TF_DOCS -->
