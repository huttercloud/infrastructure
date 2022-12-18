# https://medium.com/@reefland/migrating-unifi-network-controller-from-docker-to-kubernetes-5aac8ed8da76

resource "kubernetes_persistent_volume_claim" "unifi_conf" {
  metadata {
    name = "unifi-config"
    labels = {
      "app.kubernetes.io/name" = "unifi"
    }
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    storage_class_name = var.storage_class_name
    resources {
      requests = {
        storage = "5Gi"
      }
    }
  }
}

resource "kubernetes_deployment" "unifi" {
  metadata {
    name = "unifi"
    labels = {
      "app.kubernetes.io/name" = "unifi"
    }
  }
 
  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/name" = "unifi"
      }
    }

    strategy {
      type = "Recreate"
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/name" = "unifi"
        }
      }

      spec {
        container {
          image = "linuxserver/unifi-controller:${var.unifi_version}"
          name  = "unifi"
          port {
            container_port = 8080
            protocol = "TCP"
            name = "device-comm"
          }
          port {
            container_port = 3478
            protocol = "UDP"
            name = "stun"
          }
          port {
            container_port = 8443
            protocol = "TCP"
            name = "console"
          }
          port {
            container_port = 8843
            protocol = "TCP"
            name = "secure-redirect"
          }
          port {
            container_port = 8880
            protocol = "TCP"
            name = "http-redirect"
          }
          port {
            container_port = 6789
            protocol = "TCP"
            name = "speedtest"
          }
          port {
            container_port = 10001
            protocol = "UDP"
            name = "unifi-disc"
          }
          port {
            container_port = 1900
            protocol = "UDP"
            name = "unifi-disc-12"
          }
          env {
            name = "TZ"
            value = "Europe/Zurich"
          }
          volume_mount {
            name = "unifi-config"
            mount_path = "/config"
          }
        }
        volume {
          name = "unifi-config"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.unifi_conf.metadata.0.name
          }
        }
      }
    }
  }
}



resource "kubernetes_service" "unifi" {
  metadata {
    name = "unifi"
    labels = {
      "app.kubernetes.io/name" = "unifi"
    }
  }
  spec {
    selector = {
      "app.kubernetes.io/name" = "unifi"
    }
    port {
      name = "device-comm"
      protocol = "TCP"
      port = 8080
      target_port = 8080
    }
    port {
      name = "stun"
      protocol = "UDP"
      port = 3478
      target_port = 3478
    }
    port {
      name = "default-console"
      protocol = "TCP"
      port = 8443
      target_port = 8443
    }
    port {
      name = "secure-redirect"
      protocol = "TCP"
      port = 8843
      target_port = 8843
    }
    port {
      name = "http-redirect"
      protocol = "TCP"
      port = 8880
      target_port = 8880
    }
    port {
      name = "speedtest"
      protocol = "TCP"
      port = 6789
      target_port = 6789
    }
    port {
      name = "unifi-disc"
      protocol = "UDP"
      port = 10001
      target_port = 10001
    }
    port {
      name = "unifi-disc-12"
      protocol = "UDP"
      port = 1900
      target_port = 1900
    }

    external_ips = [ var.unifi_external_ip ]

  }
}

resource "kubernetes_ingress_v1" "unifi" {
  metadata {
    name = "unifi"
    annotations = {
      "cert-manager.io/cluster-issuer" = "letsencrypt-dns"
      "kubernetes.io/ingress.class" = "public"
      "nginx.ingress.kubernetes.io/ssl-redirect" = "true"
      "nginx.ingress.kubernetes.io/backend-protocol" = "HTTPS"
    }
  }
  spec {
    tls {
      hosts = [ var.unifi_hostname ]
      secret_name = "unifi-tls"
    }
    rule {
      host = var.unifi_hostname
      http {
        path {
          path = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.unifi.metadata.0.name
              port {
                number = 8443
              }
            }
          }
        }
      }
    }
  }
}