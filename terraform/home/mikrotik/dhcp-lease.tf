



# node-a is using dhcp during setup
# after configuration with ansible node a is set
# to use static ips. nonetheless its nice to have the 
# ip documented
resource "mikrotik_dhcp_lease" "node_a" {
  address    = "192.168.30.61"
  macaddress = "EC:A8:6B:F9:87:92"
  comment    = "node-a.hutter.cloud"
  blocked    = "false"
}

