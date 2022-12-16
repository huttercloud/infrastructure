# https://www.perdian.de/blog/2022/02/21/setting-up-a-wireguard-vpn-using-kubernetes/
# https://hub.docker.com/r/linuxserver/wireguard

resource "kubernetes_config_map" "wireguard" {
  metadata {
    name = "wireguard"
    labels = {
      "app.kubernetes.io/name" = "wireguard"
    }
  }

  data = {
    "peer.conf"             = <<EOT
[Interface]
Address = $${CLIENT_IP}
PrivateKey = $(cat /config/$${PEER_ID}/privatekey-$${PEER_ID})
ListenPort = 51820
DNS = $${PEERDNS}

[Peer]
PublicKey = $(cat /config/server/publickey-server)
PresharedKey = $(cat /config/$${PEER_ID}/presharedkey-$${PEER_ID})
Endpoint = $${SERVERURL}:$${SERVERPORT}
AllowedIPs = 192.168.30.0/24
EOT
    "server.conf"             = <<EOT
[Interface]
Address = $${INTERFACE}.1
ListenPort = 51820
PrivateKey = $(cat /config/server/privatekey-server)
PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT; iptables -t nat -A POSTROUTING -o eth+ -j MASQUERADE
PostUp = sysctl -w -q net.ipv4.ip_forward=1
PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT; iptables -t nat -D POSTROUTING -o eth+ -j MASQUERADE
PostDown = sysctl -w -q net.ipv4.ip_forward=0
EOT
  }
}

resource "kubernetes_persistent_volume_claim" "wireguard_conf" {
  metadata {
    name = "wireguard-conf"
    labels = {
      "app.kubernetes.io/name" = "wireguard"
    }
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
          # use cat instead of cp as configmap is mouted with softlinks.
          command = ["sh", "-c", "mkdir -p /config/templates; cat /tmpl/peer.conf > /config/templates/peer.conf ; cat /tmpl/server.conf > /config/templates/server.conf"]
          volume_mount {
            name = "wg-conf"
            mount_path = "/config"
          }
          volume_mount {
            name = "wg-templates"
            mount_path = "/tmpl"
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
            value = "mac,katharinamb,sebastianmb,test" # profiles to create on server start
          }
          env {
            name = "SERVERURL"
            value = "wireguard.hutter.cloud"
          }
          env {
            name = "SERVERPORT"
            value = "32767"
          }
          env {
            # fix subnet for vpn clients to allow routing on mikrotik 
            # on mikrotik: /ip route add dst-address=192.168.130.0/24 gateway=192.168.30.61
            name = "INTERNAL_SUBNET"
            value = "192.168.130.0/24"
          }
          env {
            name = "PEERDNS"
            value = "192.168.30.253"
          }
          
          volume_mount {
            name = "wg-conf"
            mount_path = "/config"
          }
        }
        volume {
          name = "wg-conf"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.wireguard_conf.metadata.0.name
          }
        }
        volume {
          name = "wg-templates"
          config_map {
            name = kubernetes_config_map.wireguard.metadata.0.name
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
      port        = 32767
      target_port = 51820
      protocol = "UDP"
      name = "wg"
      # ensure we always assign the same physical port
      # on the kubernetes cluster to allow port forwarding on
      # mikrotik: 
      # /ip firewall nat add chain=dstnat action=dst-nat to-addresses=192.168.30.61 to-ports=32767 protocol=udp in-interface=bridge-vlan200 dst-port=32767
      node_port = 32767
    }

    type = "NodePort"

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
    external_name = local.externalname_hostname
  }
}
