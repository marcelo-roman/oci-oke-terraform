# oke-node-pool

OKE node pool spread across every availability domain of the region. When `image_id` is
null, the newest OKE image matching the Kubernetes version and the shape architecture
(`aarch64` for Ampere `A1`, `x86_64` otherwise) is selected. Later image releases do not
replace existing nodes; set `image_id` to roll them deliberately.

```hcl
module "node_pool" {
  source = "github.com/marcelo-roman/oci-oke-terraform//modules/oke-node-pool?ref=v0.1.0"

  compartment_id     = var.compartment_id
  cluster_id         = module.cluster.id
  name               = "oke-arm"
  kubernetes_version = module.cluster.kubernetes_version
  subnet_id          = module.network.workers_subnet_id
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
| [oci_containerengine_node_pool.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/containerengine_node_pool) | resource |
| [oci_containerengine_node_pool_option.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/containerengine_node_pool_option) | data source |
| [oci_identity_availability_domains.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/identity_availability_domains) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| cluster\_id | OCID of the cluster that owns the node pool. | `string` | n/a | yes |
| compartment\_id | OCID of the compartment where the node pool is created. | `string` | n/a | yes |
| kubernetes\_version | Kubernetes version of the nodes. Must not be newer than the control plane. | `string` | n/a | yes |
| name | Name of the node pool. | `string` | n/a | yes |
| subnet\_id | OCID of the subnet where the nodes are placed. | `string` | n/a | yes |
| availability\_domains | Availability domains the nodes are spread across. Null uses every domain of the region. | `list(string)` | `null` | no |
| boot\_volume\_size\_in\_gbs | Boot volume size in GB per node. | `number` | `50` | no |
| freeform\_tags | Freeform tags applied to the node pool and its nodes. | `map(string)` | `{}` | no |
| image\_id | OCID of the node image. Null picks the newest OKE image matching the Kubernetes version and the shape architecture. | `string` | `null` | no |
| is\_pv\_encryption\_in\_transit\_enabled | Whether traffic between the nodes and their boot volumes is encrypted. | `bool` | `true` | no |
| memory\_in\_gbs | Memory in GB per node. Only applies to flexible shapes. | `number` | `12` | no |
| node\_labels | Kubernetes labels applied to the nodes. | `map(string)` | `{}` | no |
| ocpus | OCPUs per node. Only applies to flexible shapes. | `number` | `2` | no |
| shape | Compute shape of the nodes. | `string` | `"VM.Standard.A1.Flex"` | no |
| size | Number of nodes. | `number` | `2` | no |
| ssh\_public\_key | SSH public key installed on the nodes. Null disables SSH key injection. | `string` | `null` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| id | OCID of the node pool. |
| image\_id | OCID of the image the node pool was created with. |
| nodes | Name and private IP of every node in the pool. |
<!-- END_TF_DOCS -->
