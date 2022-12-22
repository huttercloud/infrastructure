

##
# multimedia devices
##

resource "mikrotik_dhcp_lease" "chromecast" {
  address    = "192.168.30.11"
  macaddress = "80:D2:1D:01:55:96"
  comment    = "chromecast.hutter.cloud"
  blocked    = "false"
}

resource "mikrotik_dhcp_lease" "apple_tv" {
  address    = "192.168.30.12"
  macaddress = "AC:BC:32:64:8A:71"
  comment    = "apple-tv.hutter.cloud"
  blocked    = "false"
}

resource "mikrotik_dhcp_lease" "harmony_hub" {
  address    = "192.168.30.14"
  macaddress = "00:04:20:EB:E9:8A"
  comment    = "harmony-hub.hutter.cloud"
  blocked    = "false"
}

resource "mikrotik_dhcp_lease" "plex_tv" {
  address    = "192.168.30.27"
  macaddress = "14:98:77:3B:B0:D4"
  comment    = "harmony-hub.hutter.cloud"
  blocked    = "false"
}

resource "mikrotik_dhcp_lease" "hdmi_switch_newschool" {
  address    = "192.168.30.31"
  macaddress = "00:1C:91:04:C3:2F"
  comment    = "hdmi-switch-newschool.hutter.cloud"
  blocked    = "false"
}

resource "mikrotik_dhcp_lease" "hdmi_switch_oldschool" {
  address    = "192.168.30.32"
  macaddress = "00:1C:91:04:C3:55"
  comment    = "hdmi-switch-oldschool.hutter.cloud"
  blocked    = "false"
}

resource "mikrotik_dhcp_lease" "homeassistant" {
  address    = "192.168.30.182"
  macaddress = "B8:27:EB:9B:65:33"
  comment    = "homeassistant.hutter.cloud"
  blocked    = "false"
}

##
# home lan devices
##

resource "mikrotik_dhcp_lease" "nas" {
  address    = "192.168.30.17"
  macaddress = "00:11:32:87:1A:FD"
  comment    = "nas.hutter.cloud"
  blocked    = "false"
}


resource "mikrotik_dhcp_lease" "uap" {
  address    = "192.168.30.88"
  macaddress = "78:8A:20:DC:58:B1"
  comment    = "uap.hutter.cloud"
  blocked    = "false"
}

resource "mikrotik_dhcp_lease" "printer" {
  address    = "192.168.30.51"
  macaddress = "3C:2A:F4:47:86:7D"
  comment    = "printer.hutter.cloud"
  blocked    = "false"
}

resource "mikrotik_dhcp_lease" "scanner" {
  address    = "192.168.30.52"
  macaddress = "00:80:92:DA:EA:5C"
  comment    = "scanner.hutter.cloud"
  blocked    = "false"
}


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

resource "mikrotik_dhcp_lease" "node_b" {
  address    = "192.168.30.90"
  macaddress = "2C:F0:5D:1F:FD:A6"
  comment    = "node-b.hutter.cloud"
  blocked    = "false"
}






