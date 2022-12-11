resource "pihole_dns_record" "pihole" {
  domain = "pihole.hutter.cloud"
  ip     = "192.168.30.253"
}

resource "pihole_dns_record" "hello-world" {
  domain = "hello-world.hutter.cloud"
  ip     = "192.168.30.61"
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
