resource "pihole_dns_record" "pihole" {
  domain = "pihole.hutter.cloud"
  ip     = "192.168.30.253"
}