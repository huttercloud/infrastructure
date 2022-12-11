# https://www.perdian.de/blog/2022/02/21/setting-up-a-wireguard-vpn-using-kubernetes/

resource "kubernetes_secret" "wireguard" {
  metadata {
    name = "wireguard"
    labels = {
      "app.kubernetes.io/name" = "wireguard"
    }
  }
  
  data = {
    "wg0.conf.template" = <<EOT

    [Interface]
    Address = 192.168.130.0/24
    ListenPort = 51820
    PrivateKey = ${var.wireguard_server_private_key}
    PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT; iptables -t nat -A POSTROUTING -o ENI -j MASQUERADE
    PostUp = sysctl -w -q net.ipv4.ip_forward=1
    PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT; iptables -t nat -D POSTROUTING -o ENI -j MASQUERADE
    PostDown = sysctl -w -q net.ipv4.ip_forward=0

    [Peer]
    # macbook
    PublicKey = AOIzLd2C71DtY8DWgUfuMllRNa0iR1O3tO2WbFO7ICU=
    AllowedIPs = ${var.wireguard_client_sebastian_public_key}
EOT
  }
}

resource "kubernetes_daemonset" "wireguard" {
  metadata {
    name = "wireguard"
    labels = {
      "app.kubernetes.io/name" = "wireguard"
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/name" = "wireguard"
      }
    }

    strategy {
      type = "OnDelete"
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/name" = "wireguard"
        }
      }

      spec {
        init_container {
          image = "busybox"
          name = "wg-init"
          command = ["sh", "-c", "ENI=$(ip route get 192.168.30.254 | grep 192.168.30.254 | awk '{print $5}'); sed \"s/ENI/$ENI/g\" /etc/wireguard-secret/wg0.conf.template > /etc/wireguard/wg0.conf; chmod 400 /etc/wireguard/wg0.conf"]
          volume_mount {
            name = "wg-conf"
            mount_path = "/etc/wireguard/"
          }
          volume_mount {
            name = "wg-secret"
            mount_path = "/etc/wireguard-secret/"
          }
        }
        container {
          image = "linuxserver/wireguard:${local.wireguard_version}"
          name  = "wireguard"
          security_context {
            privileged = true
            capabilities {
              add = [
                "NET_ADMIN"
              ]
            }
          }
          port {
            container_port = 51820
            protocol = "UDP"
            name = "wg"
          }
          env {
            name = "TZ"
            value = "Europe/Zurich"
          }
          env {
            name = "PEERS"
            value = "placeholder" # kept to drop into server mount
          }
          volume_mount {
            name = "wg-conf"
            mount_path = "/etc/wireguard/"
          }
        }
        volume {
          name = "wg-conf"
          empty_dir {}
        }
        volume {
          name = "wg-secret"
          secret {
            secret_name = kubernetes_secret.wireguard.metadata.0.name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "wireguard" {
  metadata {
    name = "wireguard"
    labels = {
      "app.kubernetes.io/name" = "wireguard"
    }
  }
  spec {
    selector = {
      "app.kubernetes.io/name" = "wireguard"
    }
    port {
      port        = 51820
      target_port = 51820
      protocol = "UDP"
      name = "wg"
    }
  }
}

resource "kubernetes_service" "wireguard_external_name" {
  metadata {
    name = "wireguard-external"
    labels = {
      "app.kubernetes.io/name" = "wireguard"
    }
    annotations = {
      "external-dns.alpha.kubernetes.io/hostname" = "wireguard.hutter.cloud"
      "hutter.cloud/dns-service" =  "aws"
    }
  }
  spec {
    type = "ExternalName"
    external_name = "home.hutter.cloud"
    port {
      port        = 51820
      target_port = 51820
      protocol = "UDP"
      name = "wg"
    }
  }
}
