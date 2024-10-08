terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }
}

provider "kubernetes" {
  config_path = var.kubeconfig_path
}

# Kubernetes namespace
resource "kubernetes_namespace" "example" {
  metadata {
    name = var.namespace
    labels = {
      Name   = "YOURORG-eksmanifest-resources"
      Project = "EKS-Manifest"
      Env     = "Sandbox_dev"
    }
  }
}

# Kubernetes Secret for SSL certificates
resource "kubernetes_secret" "ssl_secret" {
  metadata {
    name      = var.ssl_secret_name
    namespace = kubernetes_namespace.example.metadata[0].name
    labels = {
      Name   = "YOURORG-eksmanifest-resources"
      Project = "EKS-Manifest"
      Env     = "Sandbox_dev"
    }
  }

  data = {
    "tls.crt" = var.ssl_certificate
    "tls.key" = var.ssl_key
  }
}

# Kubernetes Ingress
resource "kubernetes_ingress_v1" "example_ingress" {
  metadata {
    name      = var.ingress_name
    namespace = kubernetes_namespace.example.metadata[0].name
    labels = {
      Name   = "YOURORG-eksmanifest-resources"
      Project = "EKS-Manifest"
      Env     = "Sandbox_dev"
    }
  }

  spec {
    tls {
      hosts       = [var.host]
      secret_name = kubernetes_secret.ssl_secret.metadata[0].name
    }

    rule {
      host = var.host

      http {
        path {
          path     = "/"
          path_type = "Prefix"

          backend {
            service {
              name = kubernetes_service.example_service.metadata[0].name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}

# Kubernetes Deployment
resource "kubernetes_deployment_v1" "example_deployment" {  # Use v1 here
  metadata {
    name      = var.deployment_name
    namespace = kubernetes_namespace.example.metadata[0].name
    labels = {
      app     = var.app_label
      Name    = "YOURORG-eksmanifest-resources"
      Project = "EKS-Manifest"
      Env     = "Sandbox_dev"
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = var.app_label
      }
    }

    template {
      metadata {
        labels = {
          app    = var.app_label
          Name   = "YOURORG-eksmanifest-resources"
          Project = "EKS-Manifest"
          Env     = "Sandbox_dev"
        }
      }

      spec {
        container {
          name  = var.container_name
          image = var.container_image

          port {
            container_port = 8080
          }

          env {
            name = "EXAMPLE_ENV"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.ssl_secret.metadata[0].name
                key  = "tls.crt"
              }
            }
          }

          volume_mount {
            name      = "config-volume"
            mount_path = "/etc/config"
          }

          volume_mount {
            name       = "efs-storage"
            mount_path = "/mnt/efs"
          }
        }

        volume {
          name = "config-volume"

          config_map {
            name = kubernetes_config_map.example_configmap.metadata[0].name
          }
        }

        volume {
          name = "efs-storage"

          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.example_pvc.metadata[0].name
          }
        }
      }
    }
  }
}

# Kubernetes Service
resource "kubernetes_service" "example_service" {
  metadata {
    name      = var.service_name
    namespace = kubernetes_namespace.example.metadata[0].name
    labels = {
      app     = var.app_label
      Name    = "YOURORG-eksmanifest-resources"
      Project = "EKS-Manifest"
      Env     = "Sandbox_dev"
    }
  }

  spec {
    selector = {
      app = var.app_label
    }

    port {
      port        = 80
      target_port = 8080
    }
  }
}

# Kubernetes Horizontal Pod Autoscaler
resource "kubernetes_horizontal_pod_autoscaler_v2" "example_hpa" {
  metadata {
    name      = var.hpa_name
    namespace = kubernetes_namespace.example.metadata[0].name
    labels = {
      app     = var.app_label
      Name    = "YOURORG-eksmanifest-resources"
      Project = "EKS-Manifest"
      Env     = "Sandbox_dev"
    }
  }

  spec {
    scale_target_ref {
      kind        = "Deployment"
      name        = kubernetes_deployment_v1.example_deployment.metadata[0].name  # Reference v1
      api_version = "apps/v1"
    }

    min_replicas = 1
    max_replicas = 10

    metric {
      type = "Resource"

      resource {
        name = "cpu"
        target {
          type               = "Utilization"
          average_utilization = 80
        }
      }
    }
  }
}

# Kubernetes Persistent Volume
resource "kubernetes_persistent_volume" "example_pv" {
  metadata {
    name = var.pv_name
    labels = {
      app     = var.app_label
      Name    = "YOURORG-eksmanifest-resources"
      Project = "EKS-Manifest"
      Env     = "Sandbox_dev"
    }
  }

  spec {
    capacity = {
      storage = "5Gi"
    }

    access_modes = ["ReadWriteMany"]

    persistent_volume_reclaim_policy = "Retain"

    storage_class_name = var.storage_class_name

    persistent_volume_source {
      csi {
        driver       = "efs.csi.aws.com"
        volume_handle = var.efs_volume_handle
      }
    }
  }
}

# Kubernetes Persistent Volume Claim
resource "kubernetes_persistent_volume_claim" "example_pvc" {
  metadata {
    name      = var.pvc_name
    namespace = kubernetes_namespace.example.metadata[0].name
    labels = {
      app     = var.app_label
      Name    = "YOURORG-eksmanifest-resources"
      Project = "EKS-Manifest"
      Env     = "Sandbox_dev"
    }
  }

  spec {
    access_modes = ["ReadWriteMany"]

    resources {
      requests = {
        storage = "5Gi"
      }
    }

    storage_class_name = var.storage_class_name
  }
}

# Kubernetes ConfigMap
resource "kubernetes_config_map" "example_configmap" {
  metadata {
    name      = var.configmap_name
    namespace = kubernetes_namespace.example.metadata[0].name
    labels = {
      app     = var.app_label
      Name    = "YOURORG-eksmanifest-resources"
      Project = "EKS-Manifest"
      Env     = "Sandbox_dev"
    }
  }

  data = {
    "config-file.conf" = var.config_content
  }
}

# Simple Busybox Pod for Testing
resource "kubernetes_pod" "busybox" {
  metadata {
    name      = "busybox"
    namespace = kubernetes_namespace.example.metadata[0].name
    labels = {
      app     = var.app_label
      Name    = "YOURORG-eksmanifest-resources"
      Project = "EKS-Manifest"
      Env     = "Sandbox_dev"
    }
  }

  spec {
    container {
      name    = "busybox"
      image   = "busybox:latest"
      command = ["sleep", "3600"]
    }
  }
}
