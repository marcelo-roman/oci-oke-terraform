# platform

Installs the add-ons on a cluster created by `examples/always-free`: Traefik, cert-manager,
metrics-server, External Secrets Operator, Argo CD, Argo Rollouts, Argo Workflows, Keycloak
and the Prometheus/Grafana stack. Each one can be switched off in `addons`.

It is a separate configuration on purpose: the `helm` and `kubernetes` providers need a
running cluster, so they cannot be configured in the same apply that creates it.

```bash
cp terraform.tfvars.example terraform.tfvars   # cluster_id and vault_id from examples/always-free
terraform init
terraform apply
```

With `domain` set, point `*.<domain>` to the Traefik load balancer IP:

```bash
kubectl -n traefik get svc traefik -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| terraform | >= 1.7 |
| helm | ~> 3.3 |
| kubernetes | ~> 3.3 |
| oci | ~> 9.8 |
| random | ~> 3.9 |

## Providers

| Name | Version |
| ---- | ------- |
| oci | ~> 9.8 |

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| argo\_rollouts | ../../modules/argo-rollouts | n/a |
| argo\_workflows | ../../modules/argo-workflows | n/a |
| argocd | ../../modules/argocd | n/a |
| cert\_manager | ../../modules/cert-manager | n/a |
| cloudnative\_pg | ../../modules/cloudnative-pg | n/a |
| external\_secrets | ../../modules/external-secrets | n/a |
| keycloak | ../../modules/keycloak | n/a |
| metrics\_server | ../../modules/metrics-server | n/a |
| monitoring | ../../modules/monitoring | n/a |
| traefik | ../../modules/traefik | n/a |

## Resources

| Name | Type |
| ---- | ---- |
| [oci_containerengine_cluster_kube_config.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/containerengine_cluster_kube_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| cluster\_id | OCID of the OKE cluster, the cluster\_id output of examples/always-free. | `string` | n/a | yes |
| region | OCI region of the cluster, e.g. sa-saopaulo-1. | `string` | n/a | yes |
| acme\_email | Email registered with Let's Encrypt. Null disables TLS on the Ingresses. | `string` | `null` | no |
| addons | Add-ons to install. | ```object({ traefik = optional(bool, true) cert_manager = optional(bool, true) metrics_server = optional(bool, true) external_secrets = optional(bool, true) argocd = optional(bool, true) argo_rollouts = optional(bool, true) argo_workflows = optional(bool, true) keycloak = optional(bool, true) monitoring = optional(bool, true) })``` | `{}` | no |
| cluster\_issuer | ClusterIssuer used when acme\_email is set: letsencrypt-staging while testing, letsencrypt-prod afterwards. | `string` | `"letsencrypt-staging"` | no |
| domain | Base domain whose subdomains point to the Traefik load balancer, e.g. lab.example.com. Null disables every Ingress; reach the UIs with kubectl port-forward. | `string` | `null` | no |
| oci\_profile | Profile from ~/.oci/config used to authenticate. | `string` | `"DEFAULT"` | no |
| oci\_vault\_id | OCID of the OCI Vault read by External Secrets Operator, the vault\_id output of examples/always-free. Null installs the operator without a ClusterSecretStore. | `string` | `null` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| argo\_rollouts\_dashboard\_command | Command that exposes the Argo Rollouts dashboard on localhost:3100. |
| argocd\_admin\_password\_command | Command that prints the initial Argo CD admin password. |
| cluster\_secret\_store | ClusterSecretStore backed by OCI Vault. |
| grafana\_admin\_password | Password of the Grafana administrator. |
| keycloak\_admin\_password | Password of the Keycloak bootstrap administrator. |
| urls | URLs of the UIs exposed through Traefik. |
<!-- END_TF_DOCS -->
