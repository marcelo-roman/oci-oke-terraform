output "namespace" {
  description = "Namespace where Traefik is installed."
  value       = helm_release.this.namespace
}

output "ingress_class_name" {
  description = "IngressClass served by Traefik."
  value       = "traefik"
}

output "chart_version" {
  description = "Installed chart version."
  value       = helm_release.this.version
}
