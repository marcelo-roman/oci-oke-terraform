# argo-workflows

Argo Workflows controller and server. The server defaults to `client` auth mode, which requires a Kubernetes bearer token.

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
| auth\_modes | Authentication modes of the Argo Server. 'client' requires a Kubernetes bearer token; 'server' grants everyone the server's permissions and must not be exposed. | `list(string)` | ```[ "client" ]``` | no |
| chart\_version | Version of the argo/argo-workflows chart. | `string` | `"2.0.11"` | no |
| cluster\_issuer | cert-manager ClusterIssuer that signs the TLS certificate. Null serves the Ingress without TLS. | `string` | `null` | no |
| hostname | Public hostname. Null disables the Ingress. | `string` | `null` | no |
| ingress\_class\_name | IngressClass of the Ingress. | `string` | `"traefik"` | no |
| namespace | Namespace where Argo Workflows is installed. | `string` | `"argo"` | no |
| values | Extra YAML values applied after the module defaults. | `list(string)` | `[]` | no |
| workflow\_namespaces | Namespaces where workflows run; each gets the service account the workflow pods use. | `list(string)` | ```[ "argo" ]``` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| chart\_version | Installed chart version. |
| namespace | Namespace where Argo Workflows is installed. |
| url | URL of the Argo Workflows UI, null when the Ingress is disabled. |
<!-- END_TF_DOCS -->
