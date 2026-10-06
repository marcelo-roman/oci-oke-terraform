# Troubleshooting

## `Out of host capacity`

A1 capacity is scarce in many regions. The node pool is created, but its nodes stay in
`CREATING` and the pool reports the error. OKE keeps retrying on its own. To speed it up:

- pin `availability_domains` in the node pool module to a single domain and try each one;
- lower `size` to 1 and raise it once the first node is up;
- upgrade the tenancy to Pay As You Go, which is served before free-trial tenancies.

## `LimitExceeded` on the NAT gateway

Free-trial tenancies cannot create NAT gateways. Upgrade to Pay As You Go; see
[always-free.md](always-free.md).

## `No OKE image matches ...`

The node pool module found no image for the requested Kubernetes version and architecture,
usually because the version was just released or is no longer offered. List what exists
and set `image_id` explicitly:

```bash
oci ce node-pool-options get --node-pool-option-id <cluster ocid> \
  --query 'data.sources[].["source-name","image-id"]' --output table
```

## `401-NotAuthenticated`

The profile in `oci_profile` uses a session token that expired. Run
`oci session refresh --profile <name>` or switch to an API key profile.

## Destroy hangs on subnets

A load balancer or volume created by Kubernetes still uses the subnet. Delete the
`LoadBalancer` Services and PersistentVolumeClaims, or remove the leftover resources from
the console, then run `make destroy` again.

## Nodes are `NotReady`

Check egress: nodes pull images through the NAT gateway and talk to OKE through the service
gateway. `oci network route-table get` on the workers route table must show both rules.
