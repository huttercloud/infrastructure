locals {
  # ip addresses for A records
  mikrotik_ip = "192.168.30.254"
  digitalocean_ip = "10.255.255.253"

  cname_records_mikrotik = [
    "wireguard.hutter.cloud",
  ]
  cname_records_digitalocean = [
    "1password-connect.hutter.cloud",
  ]
  cname_records_node_a = []
  cname_records_node_b = [
    "hello-world.hutter.cloud",
    "argocd.hutter.cloud",
    "grpc.argocd.hutter.cloud",
    "usenet.hutter.cloud",
    "prometheus.hutter.cloud",
    "grafana.hutter.cloud",
    "loki.hutter.cloud",
    "tautulli.hutter.cloud",
    "overseerr.hutter.cloud",
    "calibre.hutter.cloud",
    "calibre-content.hutter.cloud",
    "ftp.hutter.cloud",
    "calibre-opds.hutter.cloud",
    "jenkins.hutter.cloud",
    "grafana-rqarg.hutter.cloud",
  ]

  dhcp_leases_from_mikrotik = data.terraform_remote_state.mikrotik.outputs.dhcp_leases
}

##
# A Records
##

# pi-hole and 1password connect are both running on a digitalocean node
# connected via a wireguard tunnel from the mikrotik router
resource "pihole_dns_record" "digitalocean" {
  domain = "digitalocean.hutter.cloud"
  ip = local.digitalocean_ip
}

resource "pihole_dns_record" "mikrotik" {
  domain = "mikrotik.hutter.cloud"
  ip = local.mikrotik_ip
}


# # create A records from mikrotik leases

resource "pihole_dns_record" "static_leases" {
    for_each = local.dhcp_leases_from_mikrotik

    domain = each.value.comment
    ip     = each.value.address
}

# cname records pointing to nodes
resource "pihole_cname_record" "mikrotik" {
  for_each = toset(local.cname_records_mikrotik)
  domain   = each.value
  target   = "mikrotik.hutter.cloud"
}

resource "pihole_cname_record" "digitalocean" {
  for_each = toset(local.cname_records_digitalocean)
  domain   = each.value
  target   = "digitalocean.hutter.cloud"
}
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
