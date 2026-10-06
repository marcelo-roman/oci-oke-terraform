# always-free

Complete configuration that fills the Always Free A1 allowance: a Basic cluster and two
`VM.Standard.A1.Flex` nodes with 2 OCPU and 12 GB each.

```bash
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan -out=tfplan
terraform apply tfplan
eval "$(terraform output -raw kubeconfig_command)"
kubectl get nodes
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| terraform | >= 1.7 |
| oci | ~> 9.8 |

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| oke | ../.. | n/a |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| api\_allowed\_cidrs | CIDRs allowed to reach the Kubernetes API. | `list(string)` | n/a | yes |
| compartment\_id | OCID of the compartment where the cluster is created. | `string` | n/a | yes |
| region | OCI region identifier, e.g. sa-saopaulo-1. | `string` | n/a | yes |
| cluster\_name | Name of the cluster. | `string` | `"oke"` | no |
| kubernetes\_version | Kubernetes version such as v1.33.1. Null picks the newest one. | `string` | `null` | no |
| oci\_profile | Profile from ~/.oci/config used to authenticate. | `string` | `"DEFAULT"` | no |
| ssh\_public\_key | SSH public key installed on the nodes. | `string` | `null` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| api\_public\_endpoint | Public endpoint of the Kubernetes API. |
| cluster\_id | OCID of the cluster. |
| kubeconfig\_command | Command that writes the cluster credentials to ~/.kube/config. |
| kubernetes\_version | Kubernetes version of the control plane. |
| node\_pools | OCID and nodes of every node pool. |
<!-- END_TF_DOCS -->
