# Always Free

| Resource                 | Always Free allowance                     | Used by default          |
| ------------------------ | ----------------------------------------- | ------------------------ |
| OKE Basic control plane  | free                                      | 1 cluster                |
| Ampere A1 compute        | 4 OCPU and 24 GB in total                 | 2 nodes × 2 OCPU × 12 GB |
| Block volume             | 200 GB in total, boot volumes included    | 2 × 50 GB                |
| Flexible load balancer   | 1 at 10 Mbps                              | none                     |
| VCN, gateways            | free                                      | 1 VCN, 3 gateways        |

Keep `Σ size × ocpus ≤ 4` and `Σ size × memory_in_gbs ≤ 24` across every A1 pool.

## Pay As You Go

Free-trial tenancies have a NAT gateway quota of zero and rarely get A1 capacity in busy
regions. Upgrading the tenancy to Pay As You Go removes those limits while Always Free
resources stay free. Set a budget alert right after upgrading:

```bash
oci budgets budget create --compartment-id <tenancy ocid> --amount 1 \
  --reset-period MONTHLY --target-type COMPARTMENT --targets '["<tenancy ocid>"]'
```

## What costs money

- `cluster_type = "ENHANCED_CLUSTER"`
- A1 usage above 4 OCPU / 24 GB, or any other shape
- Block storage above 200 GB, including PersistentVolumes
- A second load balancer, or a load balancer above 10 Mbps
