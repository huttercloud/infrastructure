locals {
  cname_records_node_a = [

  ]

  cname_records_node_b = [
    "hello-world.hutter.cloud",
    "argocd.hutter.cloud",
    "grpc.argocd.hutter.cloud",
    "usenet.hutter.cloud",
    "prometheus.hutter.cloud",
    "grafana.hutter.cloud",
  ]

  dhcp_leases_from_mikrotik = data.terraform_remote_state.mikrotik.outputs.dhcp_leases
}

##
# A Records
##

# pihole, unifi and wireguard are all using the virtual ip on node-a
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

# create A records from mikrotik leases

resource "pihole_dns_record" "static_leases" {
    for_each = local.dhcp_leases_from_mikrotik

    domain = each.value.comment
    ip     = each.value.address
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
