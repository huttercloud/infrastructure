locals {
    cname_records_node_a = [
        "hello-world.hutter.cloud",
    ]
}

resource "pihole_dns_record" "pihole" {
  domain = "pihole.hutter.cloud"
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
  ip     = "192.168.30.34"
}

# cname records pointing to node a

resource "pihole_cname_record" "node_a" {
  for_each = toset(local.cname_records_node_a)
  domain = each.value
  target = "node-a.hutter.cloud"
}
