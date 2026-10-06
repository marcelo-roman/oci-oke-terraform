# network

VCN for an OKE cluster with three subnets — a public one for the Kubernetes API endpoint,
a private one for the nodes and a public one for the load balancers — plus internet, NAT
and service gateways, route tables and the security lists OKE needs with the flannel
overlay.

```hcl
module "network" {
  source = "github.com/marcelo-roman/oci-oke-terraform//modules/network?ref=v0.1.0"

  compartment_id    = var.compartment_id
  name              = "oke"
  api_allowed_cidrs = ["203.0.113.10/32"]
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
| [oci_core_internet_gateway.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_internet_gateway) | resource |
| [oci_core_nat_gateway.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_nat_gateway) | resource |
| [oci_core_route_table.private](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_route_table) | resource |
| [oci_core_route_table.public](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_route_table) | resource |
| [oci_core_security_list.api_endpoint](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_security_list) | resource |
| [oci_core_security_list.load_balancers](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_security_list) | resource |
| [oci_core_security_list.workers](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_security_list) | resource |
| [oci_core_service_gateway.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_service_gateway) | resource |
| [oci_core_subnet.api_endpoint](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_subnet) | resource |
| [oci_core_subnet.load_balancers](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_subnet) | resource |
| [oci_core_subnet.workers](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_subnet) | resource |
| [oci_core_vcn.this](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_vcn) | resource |
| [oci_core_services.all](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/core_services) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| api\_allowed\_cidrs | CIDRs allowed to reach the Kubernetes API on port 6443. | `list(string)` | n/a | yes |
| compartment\_id | OCID of the compartment where the network is created. | `string` | n/a | yes |
| name | Prefix for the display name of every network resource. | `string` | n/a | yes |
| api\_endpoint\_subnet\_cidr | CIDR of the public subnet that hosts the Kubernetes API endpoint. | `string` | `"10.0.0.0/28"` | no |
| freeform\_tags | Freeform tags applied to every resource. | `map(string)` | `{}` | no |
| load\_balancer\_allowed\_cidrs | CIDRs allowed to reach the load balancers on ports 80 and 443. | `list(string)` | ```[ "0.0.0.0/0" ]``` | no |
| load\_balancers\_subnet\_cidr | CIDR of the public subnet that hosts the load balancers created by Services. | `string` | `"10.0.20.0/24"` | no |
| vcn\_cidr | CIDR block of the VCN. | `string` | `"10.0.0.0/16"` | no |
| workers\_subnet\_cidr | CIDR of the private subnet that hosts the worker nodes. | `string` | `"10.0.10.0/24"` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| api\_endpoint\_subnet\_id | OCID of the subnet that hosts the Kubernetes API endpoint. |
| load\_balancers\_subnet\_id | OCID of the subnet that hosts the load balancers. |
| nat\_gateway\_id | OCID of the NAT gateway used by the workers. |
| vcn\_id | OCID of the VCN. |
| workers\_subnet\_id | OCID of the subnet that hosts the worker nodes. |
<!-- END_TF_DOCS -->
