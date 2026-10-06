# traefik

Traefik as the cluster ingress controller, exposed through an OCI flexible load balancer sized for the Always Free 10 Mbps shape.

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
| chart\_version | Version of the traefik/traefik chart. | `string` | `"41.6.1"` | no |
| is\_default\_ingress\_class | Whether the traefik IngressClass is the cluster default. | `bool` | `true` | no |
| load\_balancer\_bandwidth\_mbps | Bandwidth of the OCI flexible load balancer. 10 Mbps is the Always Free shape. | `number` | `10` | no |
| namespace | Namespace where Traefik is installed. | `string` | `"traefik"` | no |
| redirect\_to\_https | Whether plain HTTP requests are redirected to HTTPS. | `bool` | `true` | no |
| replicas | Number of Traefik pods. | `number` | `1` | no |
| service\_annotations | Extra annotations merged into the LoadBalancer Service, overriding the OCI defaults. | `map(string)` | `{}` | no |
| values | Extra YAML values applied after the module defaults. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| chart\_version | Installed chart version. |
| ingress\_class\_name | IngressClass served by Traefik. |
| namespace | Namespace where Traefik is installed. |
<!-- END_TF_DOCS -->
