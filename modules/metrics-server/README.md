# metrics-server

metrics-server, which OKE Basic clusters do not ship, for `kubectl top` and HorizontalPodAutoscalers.

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
| chart\_version | Version of the metrics-server chart. | `string` | `"3.14.0"` | no |
| kubelet\_insecure\_tls | Skip verification of the kubelet serving certificates. Needed on clusters whose kubelets use self-signed certificates. | `bool` | `false` | no |
| namespace | Namespace where metrics-server is installed. | `string` | `"kube-system"` | no |
| values | Extra YAML values applied after the module defaults. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| chart\_version | Installed chart version. |
| namespace | Namespace where metrics-server is installed. |
<!-- END_TF_DOCS -->
