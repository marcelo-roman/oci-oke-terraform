# oci-oke-terraform

[![terraform](https://github.com/marcelo-roman/oci-oke-terraform/actions/workflows/terraform.yml/badge.svg)](https://github.com/marcelo-roman/oci-oke-terraform/actions/workflows/terraform.yml)

Terraform modules that provision a Kubernetes cluster on Oracle Cloud Infrastructure (OKE),
sized by default to fit the [Always Free](https://www.oracle.com/cloud/free/) tier: a
**Basic** cluster, whose control plane is free, and an ARM node pool on
`VM.Standard.A1.Flex` using the free 4 OCPU / 24 GB.

Built only with resources from the `oracle/oci` provider — no third-party modules.

```
VCN 10.0.0.0/16
├── api      10.0.0.0/28    public   Kubernetes API endpoint
├── workers  10.0.10.0/24   private  nodes, egress through NAT and service gateway
└── lb       10.0.20.0/24   public   load balancers created by Services

OKE Basic cluster · flannel overlay
└── node pools (default: 2 × A1.Flex, 2 OCPU, 12 GB), spread across ADs
```

## Repository layout

```
.
├── main.tf, variables.tf, outputs.tf    root module: wires the three modules together
├── modules/
│   ├── network/          VCN, gateways, route tables, subnets and security lists
│   ├── oke-cluster/      OKE control plane
│   ├── oke-node-pool/    node pool with automatic image selection
│   ├── oci-vault/        OCI Vault + dynamic group and policy for the nodes
│   ├── traefik/          ingress controller on an OCI flexible load balancer
│   ├── cert-manager/     certificates and Let's Encrypt ClusterIssuers
│   ├── metrics-server/   resource metrics for kubectl top and HPA
│   ├── external-secrets/ External Secrets Operator + OCI Vault ClusterSecretStore
│   ├── argocd/           GitOps
│   ├── argo-rollouts/    canary and blue-green deployments
│   ├── argo-workflows/   workflow engine
│   ├── cloudnative-pg/   PostgreSQL operator
│   ├── keycloak/         identity provider on CloudNativePG
│   └── monitoring/       Prometheus, Alertmanager and Grafana
├── tests/                root module tests (terraform test, mocked provider)
├── examples/
│   ├── always-free/      infrastructure: network, cluster, node pool, vault
│   └── platform/         add-ons installed on the cluster with helm
├── docs/                 architecture, operations, Always Free limits, troubleshooting
└── Makefile              fmt, validate, lint, docs, security, plan/apply
```

## Quick start

```bash
cd examples/always-free
cp terraform.tfvars.example terraform.tfvars   # region, compartment, your IP
cd ../..

make init
make plan
make apply
make kubeconfig
kubectl get nodes
```

Then install the add-ons with [examples/platform](examples/platform).

Requirements: Terraform >= 1.7, the [OCI CLI](https://docs.oracle.com/iaas/Content/API/SDKDocs/cliinstall.htm)
with an API key profile (`oci setup config`) and `kubectl`. The tenancy must be on
**Pay As You Go** — see [docs/always-free.md](docs/always-free.md).

## Using it as a module

```hcl
module "oke" {
  source = "github.com/marcelo-roman/oci-oke-terraform?ref=v0.1.0"

  compartment_id    = "ocid1.compartment.oc1..xxxx"
  cluster_name      = "lab"
  api_allowed_cidrs = ["203.0.113.10/32"]

  node_pools = {
    arm = { size = 2, ocpus = 2, memory_in_gbs = 12 }
  }
}
```

Each building block can also be consumed on its own, e.g.
`github.com/marcelo-roman/oci-oke-terraform//modules/network?ref=v0.1.0`.

## Development

| Command           | What it does                                              |
| ----------------- | --------------------------------------------------------- |
| `make fmt`        | `terraform fmt -recursive`                                |
| `make validate`   | `terraform validate` on the root, every module and example |
| `make test`       | `terraform test` with a mocked provider, no cloud access    |
| `make lint`       | `tflint` with the `terraform` ruleset, preset `all`       |
| `make docs`       | regenerates the inputs/outputs tables with terraform-docs |
| `make security`   | `trivy config` for HIGH and CRITICAL misconfigurations    |
| `make check`      | all of the above, as CI runs it                           |

`pre-commit install` enables the same checks on every commit. Tools: `tflint`,
`terraform-docs`, `trivy` and `pre-commit`.

## Documentation

- [Architecture](docs/architecture.md) — network layout, traffic rules and design decisions
- [Operations](docs/operations.md) — remote state, kubeconfig, upgrades, scaling and teardown
- [Always Free](docs/always-free.md) — what is free and how to stay inside it
- [Troubleshooting](docs/troubleshooting.md) — capacity errors, quotas and stuck destroys

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| terraform | >= 1.7 |
| oci | >= 9.8, < 10.0 |

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| cluster | ./modules/oke-cluster | n/a |
| network | ./modules/network | n/a |
| node\_pool | ./modules/oke-node-pool | n/a |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| api\_allowed\_cidrs | CIDRs allowed to reach the Kubernetes API on port 6443. | `list(string)` | n/a | yes |
| compartment\_id | OCID of the compartment where every resource is created. | `string` | n/a | yes |
| cluster\_name | Name of the cluster, also used as prefix for the network resources. | `string` | `"oke"` | no |
| cluster\_type | BASIC\_CLUSTER (free control plane) or ENHANCED\_CLUSTER. | `string` | `"BASIC_CLUSTER"` | no |
| freeform\_tags | Freeform tags applied to every resource. | `map(string)` | `{}` | no |
| kubernetes\_version | Kubernetes version such as v1.33.1. Null picks the newest version OKE offers; pin it to control upgrades. | `string` | `null` | no |
| load\_balancer\_allowed\_cidrs | CIDRs allowed to reach the load balancers on ports 80 and 443. | `list(string)` | ```[ "0.0.0.0/0" ]``` | no |
| network | CIDR blocks of the VCN, its subnets, the pod overlay and the Services. | ```object({ vcn_cidr = optional(string, "10.0.0.0/16") api_endpoint_subnet_cidr = optional(string, "10.0.0.0/28") workers_subnet_cidr = optional(string, "10.0.10.0/24") load_balancers_subnet_cidr = optional(string, "10.0.20.0/24") pods_cidr = optional(string, "10.244.0.0/16") services_cidr = optional(string, "10.96.0.0/16") })``` | `{}` | no |
| node\_pools | Node pools keyed by name suffix. The defaults fill the Always Free A1 allowance: 2 nodes x 2 OCPU x 12 GB. | ```map(object({ size = optional(number, 2) shape = optional(string, "VM.Standard.A1.Flex") ocpus = optional(number, 2) memory_in_gbs = optional(number, 12) boot_volume_size_in_gbs = optional(number, 50) image_id = optional(string) node_labels = optional(map(string), {}) }))``` | ```{ "default": {} }``` | no |
| ssh\_public\_key | SSH public key installed on every node. Null disables SSH key injection. | `string` | `null` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| api\_public\_endpoint | Public endpoint of the Kubernetes API. |
| cluster\_id | OCID of the cluster. |
| kubernetes\_version | Kubernetes version of the control plane. |
| node\_pools | OCID and nodes of every node pool. |
| vcn\_id | OCID of the VCN. |
<!-- END_TF_DOCS -->

## License

[MIT](LICENSE)
