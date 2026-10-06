# Architecture

## Network

```
                    internet
                       │
          ┌────────────┴────────────┐
          │     internet gateway    │
          └──────┬───────────┬──────┘
                 │           │
   ┌─────────────┴───┐   ┌───┴─────────────┐
   │ api  /28 public │   │ lb  /24 public  │
   │ Kubernetes API  │   │ load balancers  │
   └────────┬────────┘   └────────┬────────┘
            │ 6443, 12250         │ NodePorts, 10256
   ┌────────┴─────────────────────┴────────┐
   │ workers /24 private                   │
   │ nodes + pods (flannel 10.244.0.0/16)  │
   └────────┬──────────────────────┬───────┘
            │                      │
     NAT gateway          service gateway
      (internet)        (Oracle Services Network:
                         OCIR, Object Storage, OKE)
```

| Subnet    | Default CIDR   | Exposure | Route table                     |
| --------- | -------------- | -------- | ------------------------------- |
| `api`     | `10.0.0.0/28`  | public   | internet gateway                |
| `workers` | `10.0.10.0/24` | private  | NAT gateway + service gateway   |
| `lb`      | `10.0.20.0/24` | public   | internet gateway                |

Nodes never get public IPs. The only inbound paths from the internet are the API endpoint
(port 6443, restricted by `api_allowed_cidrs`) and the load balancers (80 and 443,
restricted by `load_balancer_allowed_cidrs`).

## Traffic rules

Security lists follow the rules Oracle documents for flannel overlay clusters.

**API endpoint subnet**

| Direction | Peer               | Port        | Purpose                        |
| --------- | ------------------ | ----------- | ------------------------------ |
| ingress   | allowed clients    | TCP 6443    | `kubectl`                      |
| ingress   | workers            | TCP 6443    | kubelet to API server          |
| ingress   | workers            | TCP 12250   | control plane tunnel           |
| ingress   | workers            | ICMP 3/4    | path MTU discovery             |
| egress    | Oracle services    | TCP 443     | OKE management                 |
| egress    | workers            | TCP all     | API server to kubelet          |

**Workers subnet**

| Direction | Peer               | Port            | Purpose                    |
| --------- | ------------------ | --------------- | -------------------------- |
| ingress   | workers            | all             | node and pod traffic       |
| ingress   | API endpoint       | TCP all         | control plane to kubelet   |
| ingress   | load balancers     | TCP 30000-32767 | NodePorts                  |
| ingress   | load balancers     | TCP 10256       | kube-proxy health checks   |
| egress    | anywhere           | all             | images, updates via NAT    |

**Load balancer subnet**

| Direction | Peer               | Port            | Purpose                    |
| --------- | ------------------ | --------------- | -------------------------- |
| ingress   | allowed clients    | TCP 80, 443     | application traffic        |
| egress    | workers            | TCP 30000-32767 | NodePorts                  |
| egress    | workers            | TCP 10256       | health checks              |

## Design decisions

**Basic cluster.** The control plane of a Basic cluster costs nothing; Enhanced adds
virtual nodes, managed add-ons and a financially backed SLA, and is billed per cluster
hour. Switch with `cluster_type = "ENHANCED_CLUSTER"`.

**Flannel overlay instead of VCN-native pod networking.** Pods take addresses from an
overlay, not from the VCN, so a small workers subnet is enough and A1 nodes are not limited
by the number of VNICs their shape supports.

**Security lists instead of network security groups.** OKE creates rules for the load
balancers it provisions in the subnet's security lists; keeping everything in security
lists leaves a single place to read. Moving to NSGs is the next step for finer-grained
isolation.

**Image selection by name.** OKE publishes images per Kubernetes version and architecture.
The node pool module picks the newest image whose name contains `OKE-<version>` and the
shape's architecture, and ignores later image changes so a new image release never
replaces running nodes on its own.

**No provider block in modules.** Only `examples/` configure the provider, so the modules
can be consumed with any authentication method and region.
