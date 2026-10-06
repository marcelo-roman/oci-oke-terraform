# keycloak

Keycloak (codecentric keycloakx chart, official image) backed by a PostgreSQL cluster managed by CloudNativePG. The bootstrap admin password is generated and stored in the `keycloak-admin` Secret. Requires the cloudnative-pg module.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| terraform | >= 1.7 |
| helm | >= 3.0, < 4.0 |
| kubernetes | >= 2.38, < 4.0 |
| random | >= 3.6, < 4.0 |

## Providers

| Name | Version |
| ---- | ------- |
| helm | >= 3.0, < 4.0 |
| kubernetes | >= 2.38, < 4.0 |
| random | >= 3.6, < 4.0 |

## Resources

| Name | Type |
| ---- | ---- |
| [helm_release.database](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.this](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_namespace_v1.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1) | resource |
| [kubernetes_secret_v1.admin](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret_v1) | resource |
| [random_password.admin](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| admin\_username | Username of the bootstrap administrator. | `string` | `"admin"` | no |
| chart\_version | Version of the codecentric/keycloakx chart. | `string` | `"7.3.2"` | no |
| cluster\_issuer | cert-manager ClusterIssuer that signs the TLS certificate. Null serves the Ingress without TLS. | `string` | `null` | no |
| database\_chart\_version | Version of the cnpg/cluster chart that creates the PostgreSQL cluster. Requires the CloudNativePG operator. | `string` | `"0.9.0"` | no |
| database\_instances | Number of PostgreSQL instances. | `number` | `1` | no |
| database\_storage\_size | Size of each PostgreSQL volume. OCI block volumes start at 50Gi. | `string` | `"50Gi"` | no |
| hostname | Public hostname. Null disables the Ingress. | `string` | `null` | no |
| ingress\_class\_name | IngressClass of the Ingress. | `string` | `"traefik"` | no |
| namespace | Namespace where Keycloak and its database are installed. | `string` | `"keycloak"` | no |
| replicas | Number of Keycloak pods. | `number` | `1` | no |
| storage\_class | StorageClass of the PostgreSQL volumes. Null uses the cluster default. | `string` | `null` | no |
| values | Extra YAML values applied after the module defaults. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| admin\_password | Password of the bootstrap administrator. |
| admin\_username | Username of the bootstrap administrator. |
| chart\_version | Installed chart version. |
| database\_secret | Secret with the PostgreSQL credentials created by CloudNativePG. |
| namespace | Namespace where Keycloak is installed. |
| url | URL of Keycloak, null when the Ingress is disabled. |
<!-- END_TF_DOCS -->
