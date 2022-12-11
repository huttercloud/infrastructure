
resource "kubernetes_persistent_volume_claim" "pi_hole_etc" {
  metadata {
    name = "pi-hole-etc"
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    storage_class_name = kubernetes_storage_class.persistent.metadata[0].name
    resources {
      requests = {
        storage = "5Gi"
      }
    }
  }
}


resource "kubernetes_persistent_volume_claim" "pi_hole_dnsmasq" {
  metadata {
    name = "pi-hole-dnsmasq"
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    storage_class_name = kubernetes_storage_class.persistent.metadata[0].name
    resources {
      requests = {
        storage = "5Gi"
      }
    }
  }
}

resource "kubernetes_daemonset" "pi_hole" {
  metadata {
    name = "pi-hole"
    labels = {
      "app.kubernetes.io/name" = "pi-hole"
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/name" = "pi-hole"
      }
    }

    strategy {
      type = "OnDelete"
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/name" = "pi-hole"
        }
      }

      spec {
        service_account_name = kubernetes_service_account.external_dns.metadata[0].name
        automount_service_account_token = true
        container {
          image = "pihole/pihole:${local.pi_hole_version}"
          name  = "pi-hole"
          security_context {
            privileged = true
          }
          port {
            container_port = 53
            protocol = "UDP"
            name = "dnsu"
          }
          port {
            container_port = 53
            protocol = "TCP"
            name = "dnst"
          }

          port {
            container_port = 80
            protocol = "TCP"
            name = "http"
          }
          env {
            name = "TZ"
            value = "Europe/Zurich"
          }
          env {
            name = "WEBPASSWORD"
            value = "${var.pi_hole_webpassword}"
          }
          volume_mount {
            name = "etc"
            mount_path = "/etc/pihole"
          }
          volume_mount {
            name = "dnsmasq"
            mount_path = "/etc/dnsmasq.d"
          }
        }
        volume {
          name = "etc"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.pi_hole_etc.metadata[0].name
          }
        }
        volume {
          name = "dnsmasq"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.pi_hole_dnsmasq.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "pi_hole_http" {
  metadata {
    name = "pi-hole-http"
  }
  spec {
    selector = {
      "app.kubernetes.io/name" = "pi-hole"
    }
    port {
      port        = 80
      target_port = 80
      protocol = "TCP"
      name = "http"
    }

    external_ips = [ local.pi_hole_external_ip ]
  }
}

resource "kubernetes_service" "pi_hole_dns" {
  metadata {
    name = "pi-hole-dns"
  }
  spec {
    selector = {
      "app.kubernetes.io/name" = "pi-hole"
    }
    port {
      port        = 53
      target_port = 53
      protocol = "TCP"
      name = "dnst"
    }
    port {
      port        = 53
      target_port = 53
      protocol = "UDP"
      name = "dnsu"
    }

    external_ips = [ local.pi_hole_external_ip ]
  }
}

resource "kubernetes_ingress_v1" "pi_hole" {
  metadata {
    name = "pi-hole"
    annotations = {
      "cert-manager.io/cluster-issuer" = "letsencrypt-dns"
      "kubernetes.io/ingress.class" = "public"
    }
  }
  spec {
    tls {
      hosts = [ "pihole.hutter.cloud" ]
      secret_name = "pihole-tls"
    }
    rule {
      host = "pihole.hutter.cloud"
      http {
        path {
          path = "/admin"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.pi_hole_http.metadata.0.name
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