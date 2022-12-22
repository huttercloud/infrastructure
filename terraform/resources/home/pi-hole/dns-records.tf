locals {
  cname_records_node_a = [

  ]

  cname_records_node_b = [
    "hello-world.hutter.cloud",
    "argocd.hutter.cloud",
    "grpc.argocd.hutter.cloud",
    "usenet.hutter.cloud",
    "usenet-2.hutter.cloud"
  ]
}

resource "pihole_dns_record" "pihole" {
  domain = "pihole.hutter.cloud"
  ip     = "192.168.30.253"
}

resource "pihole_dns_record" "unifi" {
  domain = "unifi.hutter.cloud"
  ip     = "192.168.30.253"
}
resource "pihole_dns_record" "wireguard" {
  domain = "wireguard.hutter.cloud"
  ip     = "192.168.30.253"
}

resource "pihole_dns_record" "nas" {
  domain = "nas.hutter.cloud"
  ip     = "192.168.30.17"
}
resource "pihole_dns_record" "homeassistant" {
  domain = "homeassistant.hutter.cloud"
  ip     = "192.168.30.182"
}

resource "pihole_dns_record" "node_a" {
  domain = "node-a.hutter.cloud"
  ip     = "192.168.30.61"
}

resource "pihole_dns_record" "node_b" {
  domain = "node-b.hutter.cloud"
  ip     = "192.168.30.90"
}

# cname records pointing to nodes

resource "pihole_cname_record" "node_a" {
  for_each = toset(local.cname_records_node_a)
  domain   = each.value
  target   = "node-a.hutter.cloud"
}

resource "pihole_cname_record" "node_b" {
  for_each = toset(local.cname_records_node_b)
  domain   = each.value
  target   = "node-b.hutter.cloud"
}