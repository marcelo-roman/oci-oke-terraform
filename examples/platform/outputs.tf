output "urls" {
  description = "URLs of the UIs exposed through Traefik."
  value = {
    argocd         = try(module.argocd[0].url, null)
    argo_workflows = try(module.argo_workflows[0].url, null)
    keycloak       = try(module.keycloak[0].url, null)
    grafana        = try(module.monitoring[0].grafana_url, null)
  }
}

output "argocd_admin_password_command" {
  description = "Command that prints the initial Argo CD admin password."
  value       = try("kubectl -n ${module.argocd[0].namespace} get secret ${module.argocd[0].initial_admin_secret} -o jsonpath='{.data.password}' | base64 -d", null)
}

output "argo_rollouts_dashboard_command" {
  description = "Command that exposes the Argo Rollouts dashboard on localhost:3100."
  value       = try(module.argo_rollouts[0].dashboard_command, null)
}

output "keycloak_admin_password" {
  description = "Password of the Keycloak bootstrap administrator."
  value       = try(module.keycloak[0].admin_password, null)
  sensitive   = true
}

output "grafana_admin_password" {
  description = "Password of the Grafana administrator."
  value       = try(module.monitoring[0].grafana_admin_password, null)
  sensitive   = true
}

output "cluster_secret_store" {
  description = "ClusterSecretStore backed by OCI Vault."
  value       = try(module.external_secrets[0].cluster_secret_store, null)
}
