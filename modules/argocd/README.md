# argocd

Argo CD without Dex, served behind Traefik with TLS terminated at the ingress. `oidc` plugs in an OpenID Connect provider such as the keycloak module.

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
| chart\_version | Version of the argo/argo-cd chart. | `string` | `"10.9.6"` | no |
| cluster\_issuer | cert-manager ClusterIssuer that signs the TLS certificate. Null serves the Ingress without TLS. | `string` | `null` | no |
| hostname | Public hostname. Null disables the Ingress. | `string` | `null` | no |
| ingress\_class\_name | IngressClass of the Ingress. | `string` | `"traefik"` | no |
| namespace | Namespace where Argo CD is installed. | `string` | `"argocd"` | no |
| oidc | OpenID Connect provider used for SSO, e.g. a Keycloak realm. Null keeps only the local admin user. | ```object({ name = optional(string, "Keycloak") issuer = string client_id = string client_secret = string scopes = optional(list(string), ["openid", "profile", "email", "groups"]) })``` | `null` | no |
| values | Extra YAML values applied after the module defaults. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| chart\_version | Installed chart version. |
| initial\_admin\_secret | Secret holding the generated password of the admin user. |
| namespace | Namespace where Argo CD is installed. |
| url | URL of the Argo CD UI, null when the Ingress is disabled. |
<!-- END_TF_DOCS -->
