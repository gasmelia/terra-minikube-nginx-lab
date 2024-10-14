resource "kubernetes_namespace" "example" {
  metadata {
    name = var.ns_name
  }
}

resource "kubernetes_deployment" "example" {
  metadata {
    name = var.image_name
    labels = {
      App = var.app_name
    }
    namespace = var.ns_name
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        App = var.app_name
      }
    }
    template {
      metadata {
        labels = {
          App = var.app_name
        }
      }
      spec {
        container {
          image = "nginx:1.21.6"
          name  = var.image_name
          port {
            container_port = 80
          }
          resources {
            limits = {
                cpu = "0.5"
                memory = "512Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "example" {
  metadata {
    name =  "nginx-example"
    namespace = kubernetes_namespace.example.id
  }
  spec {
    selector = {
      App = kubernetes_deployment.example.spec.0.template.0.metadata[0].labels.App
    }
    port {
      node_port = 30082
      port = 80
      target_port = 80
    }
    type = "NodePort"
  }
}