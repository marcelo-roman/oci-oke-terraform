# monitoring

kube-prometheus-stack: Prometheus, Alertmanager, Grafana, node-exporter and kube-state-metrics. Control-plane scrapers are disabled on managed clusters, and the Grafana admin password is generated.

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
| [helm_release.this](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_namespace_v1.this](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1) | resource |
| [kubernetes_secret_v1.grafana_admin](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret_v1) | resource |
| [random_password.grafana_admin](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| alertmanager\_enabled | Whether Alertmanager is deployed. | `bool` | `true` | no |
| chart\_version | Version of the prometheus-community/kube-prometheus-stack chart. | `string` | `"91.9.0"` | no |
| cluster\_issuer | cert-manager ClusterIssuer that signs the TLS certificate. Null serves the Ingress without TLS. | `string` | `null` | no |
| grafana\_admin\_username | Username of the Grafana administrator. | `string` | `"admin"` | no |
| hostname | Public hostname. Null disables the Ingress. | `string` | `null` | no |
| ingress\_class\_name | IngressClass of the Ingress. | `string` | `"traefik"` | no |
| managed\_control\_plane | Whether the control plane is managed by the cloud provider, which hides etcd, the scheduler and the controller manager from scraping. | `bool` | `true` | no |
| namespace | Namespace where the monitoring stack is installed. | `string` | `"monitoring"` | no |
| prometheus\_retention | How long Prometheus keeps samples. | `string` | `"3d"` | no |
| prometheus\_storage\_size | Size of the Prometheus volume. Null keeps data on an emptyDir that is lost when the pod restarts; OCI block volumes start at 50Gi. | `string` | `null` | no |
| storage\_class | StorageClass of the Prometheus volume. Null uses the cluster default. | `string` | `null` | no |
| values | Extra YAML values applied after the module defaults. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| chart\_version | Installed chart version. |
| grafana\_admin\_password | Password of the Grafana administrator. |
| grafana\_admin\_username | Username of the Grafana administrator. |
| grafana\_url | URL of Grafana, null when the Ingress is disabled. |
| namespace | Namespace where the monitoring stack is installed. |
<!-- END_TF_DOCS -->
