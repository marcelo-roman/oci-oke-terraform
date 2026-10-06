# cert-manager

cert-manager with its CRDs and, when `acme_email` is set, the `letsencrypt-staging` and `letsencrypt-prod` ClusterIssuers solving HTTP-01 through Traefik.

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
| [helm_release.cluster_issuers](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.this](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| acme\_email | Email registered with Let's Encrypt. Null skips the creation of the ClusterIssuers. | `string` | `null` | no |
| chart\_version | Version of the jetstack cert-manager chart. | `string` | `"v1.21.2"` | no |
| ingress\_class\_name | IngressClass used to solve HTTP-01 challenges. | `string` | `"traefik"` | no |
| namespace | Namespace where cert-manager is installed. | `string` | `"cert-manager"` | no |
| values | Extra YAML values applied after the module defaults. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| chart\_version | Installed chart version. |
| cluster\_issuers | Names of the ClusterIssuers created, empty when acme\_email is null. |
| namespace | Namespace where cert-manager is installed. |
<!-- END_TF_DOCS -->
