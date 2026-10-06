locals {
  load_balancer_ports = [80, 443]

  load_balancer_ingress = {
    for pair in setproduct(var.load_balancer_allowed_cidrs, local.load_balancer_ports) :
    "${pair[0]}:${pair[1]}" => { cidr = pair[0], port = pair[1] }
  }
}

resource "oci_core_security_list" "api_endpoint" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id
  display_name   = "${var.name}-api"
  freeform_tags  = var.freeform_tags

  dynamic "ingress_security_rules" {
    for_each = toset(var.api_allowed_cidrs)

    content {
      protocol    = "6"
      source      = ingress_security_rules.value
      description = "Kubernetes API from allowed clients"

      tcp_options {
        min = 6443
        max = 6443
      }
    }
  }

  ingress_security_rules {
    protocol    = "6"
    source      = var.workers_subnet_cidr
    description = "Kubernetes API from workers"

    tcp_options {
      min = 6443
      max = 6443
    }
  }

  ingress_security_rules {
    protocol    = "6"
    source      = var.workers_subnet_cidr
    description = "Control plane communication from workers"

    tcp_options {
      min = 12250
      max = 12250
    }
  }

  ingress_security_rules {
    protocol    = "1"
    source      = var.workers_subnet_cidr
    description = "Path MTU discovery"

    icmp_options {
      type = 3
      code = 4
    }
  }

  egress_security_rules {
    protocol         = "6"
    destination      = local.oci_services_cidr
    destination_type = "SERVICE_CIDR_BLOCK"
    description      = "OKE management through the service gateway"

    tcp_options {
      min = 443
      max = 443
    }
  }

  egress_security_rules {
    protocol    = "6"
    destination = var.workers_subnet_cidr
    description = "Control plane to workers"
  }

  egress_security_rules {
    protocol    = "1"
    destination = var.workers_subnet_cidr
    description = "Path MTU discovery"

    icmp_options {
      type = 3
      code = 4
    }
  }
}

resource "oci_core_security_list" "workers" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id
  display_name   = "${var.name}-workers"
  freeform_tags  = var.freeform_tags

  ingress_security_rules {
    protocol    = "all"
    source      = var.workers_subnet_cidr
    description = "Traffic between workers and pods"
  }

  ingress_security_rules {
    protocol    = "6"
    source      = var.api_endpoint_subnet_cidr
    description = "Control plane to workers"
  }

  ingress_security_rules {
    protocol    = "6"
    source      = var.load_balancers_subnet_cidr
    description = "Load balancers to NodePorts"

    tcp_options {
      min = 30000
      max = 32767
    }
  }

  ingress_security_rules {
    protocol    = "6"
    source      = var.load_balancers_subnet_cidr
    description = "Load balancer health checks on kube-proxy"

    tcp_options {
      min = 10256
      max = 10256
    }
  }

  ingress_security_rules {
    protocol    = "1"
    source      = "0.0.0.0/0"
    description = "Path MTU discovery"

    icmp_options {
      type = 3
      code = 4
    }
  }

  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
    description = "Outbound traffic through the NAT gateway"
  }

  egress_security_rules {
    protocol         = "6"
    destination      = local.oci_services_cidr
    destination_type = "SERVICE_CIDR_BLOCK"
    description      = "Oracle Services Network through the service gateway"
  }
}

resource "oci_core_security_list" "load_balancers" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id
  display_name   = "${var.name}-lb"
  freeform_tags  = var.freeform_tags

  dynamic "ingress_security_rules" {
    for_each = local.load_balancer_ingress

    content {
      protocol    = "6"
      source      = ingress_security_rules.value.cidr
      description = "Port ${ingress_security_rules.value.port} from allowed clients"

      tcp_options {
        min = ingress_security_rules.value.port
        max = ingress_security_rules.value.port
      }
    }
  }

  egress_security_rules {
    protocol    = "6"
    destination = var.workers_subnet_cidr
    description = "NodePorts on workers"

    tcp_options {
      min = 30000
      max = 32767
    }
  }

  egress_security_rules {
    protocol    = "6"
    destination = var.workers_subnet_cidr
    description = "Health checks on kube-proxy"

    tcp_options {
      min = 10256
      max = 10256
    }
  }
}
