# argo-rollouts

Argo Rollouts controller and dashboard. The dashboard has no authentication, so it is only reachable through `kubectl port-forward`.

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
| chart\_version | Version of the argo/argo-rollouts chart. | `string` | `"2.43.6"` | no |
| dashboard\_enabled | Whether the Rollouts dashboard is deployed. It has no authentication, so it is only reachable through kubectl port-forward. | `bool` | `true` | no |
| namespace | Namespace where Argo Rollouts is installed. | `string` | `"argo-rollouts"` | no |
| values | Extra YAML values applied after the module defaults. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| chart\_version | Installed chart version. |
| dashboard\_command | Command that exposes the dashboard on localhost:3100, null when the dashboard is disabled. |
| namespace | Namespace where Argo Rollouts is installed. |
<!-- END_TF_DOCS -->
