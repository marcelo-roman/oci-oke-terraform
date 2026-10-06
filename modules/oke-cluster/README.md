# oke-cluster

OKE control plane with a flannel overlay. Defaults to `BASIC_CLUSTER`, whose control plane
is free, and to the newest Kubernetes version OKE offers when `kubernetes_version` is null.

```hcl
module "cluster" {
  source = "github.com/marcelo-roman/oci-oke-terraform//modules/oke-cluster?ref=v0.1.0"

  compartment_id           = var.compartment_id
  name                     = "oke"
  vcn_id                   = module.network.vcn_id
  api_endpoint_subnet_id   = module.network.api_endpoint_subnet_id
  load_balancer_subnet_ids = [module.network.load_balancers_subnet_id]
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| terraform | >= 1.7 |
| oci | >= 9.8, < 10.0 |

## Providers

| Name | Version |
| ---- | ------- |
| oci | >= 9.8, < 10.0 |

## Resources

| Name | Type |
| ---- | ---- |
| [oci_containerengine_cluster.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/containerengine_cluster) | resource |
| [oci_containerengine_cluster_option.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/containerengine_cluster_option) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| api\_endpoint\_subnet\_id | OCID of the subnet that hosts the Kubernetes API endpoint. | `string` | n/a | yes |
| compartment\_id | OCID of the compartment where the cluster is created. | `string` | n/a | yes |
| load\_balancer\_subnet\_ids | OCIDs of the subnets where Services of type LoadBalancer are placed. | `list(string)` | n/a | yes |
| name | Name of the cluster. | `string` | n/a | yes |
| vcn\_id | OCID of the VCN that hosts the cluster. | `string` | n/a | yes |
| cluster\_type | BASIC\_CLUSTER has a free control plane; ENHANCED\_CLUSTER adds virtual nodes, add-ons and a financially backed SLA. | `string` | `"BASIC_CLUSTER"` | no |
| freeform\_tags | Freeform tags applied to the cluster. | `map(string)` | `{}` | no |
| is\_public\_endpoint | Whether the Kubernetes API endpoint gets a public IP. | `bool` | `true` | no |
| kubernetes\_version | Kubernetes version such as v1.33.1. Null picks the newest version OKE offers. | `string` | `null` | no |
| pods\_cidr | CIDR of the flannel overlay used by pods. | `string` | `"10.244.0.0/16"` | no |
| services\_cidr | CIDR used by Kubernetes Services. | `string` | `"10.96.0.0/16"` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| id | OCID of the cluster. |
| kubernetes\_version | Kubernetes version of the control plane. |
| private\_endpoint | Private endpoint of the Kubernetes API. |
| public\_endpoint | Public endpoint of the Kubernetes API, empty when the endpoint is private. |
<!-- END_TF_DOCS -->
