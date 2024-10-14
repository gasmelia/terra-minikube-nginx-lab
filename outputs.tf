output "ns_name" {
  description = "namespace"
  value       = kubernetes_namespace.example.id
}
output "cluster_name" {
  description = "minikube cluster name"
  value = kubernetes_deployment.example.id
}