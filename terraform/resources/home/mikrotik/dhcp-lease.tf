

##
# multimedia devices
##

locals {
    dhcp_leases = {
        "chromecast" = {
            macaddress = "80:D2:1D:01:55:96"
            address = "192.168.30.11"
        },
        "apple-tv" = {
            macaddress = "AC:BC:32:64:8A:71"
            address = "192.168.30.12"
        },
        "harmony-hub" = {
            macaddress = "00:04:20:EB:E9:8A"
            address = "192.168.30.14"
        },
        "plex" = {
            macaddress = "14:98:77:3B:B0:D4"
            address = "192.168.30.27"
        },
        "hdmi-switch-newschool" = {
            macaddress = "00:1C:91:04:C3:2F"
            address = "192.168.30.31"
        },
        "hdmi-switch-oldschool" = {
            macaddress = "00:1C:91:04:C3:55"
            address = "192.168.30.32"
        },
        "homeassistant" = {
            macaddress = "B8:27:EB:9B:65:33"
            address = "192.168.30.182"
        },
        "nfs" = {
            macaddress = "00:11:32:87:1A:FD"
            address = "192.168.30.17"
        },
        "uap" = {
            macaddress = "78:8A:20:DC:58:B1"
            address = "192.168.30.88"
        },
        "printer" = {
            macaddress = "3C:2A:F4:47:86:7D"
            address = "192.168.30.51"
        },
        "scanner" = {
            macaddress = "00:80:92:DA:EA:5C"
            address = "192.168.30.52"
        },
        "node-a" = {
            macaddress = "EC:A8:6B:F9:87:92"
            address = "192.168.30.61"
        },
        "node-b" = {
            macaddress = "2C:F0:5D:1F:FD:A6"
            address = "192.168.30.90"
        },
        "node-c" = {
            macaddress = "C0:3F:D5:62:7F:A3"
            address = "192.168.30.21"
        },
        "synology" = {
            macaddress = "90:09:D0:25:32:E5"
            address = "192.168.30.33"
        }
    }
}


resource "mikrotik_dhcp_lease" "leases" {
  for_each = local.dhcp_leases

  address    = each.value.address
  macaddress = each.value.macaddress
  # the comment is re-used by the pi-hole resource to create A records!
  comment    = "${each.key}.hutter.cloud"
  blocked    = "false"
}

output "dhcp_leases" {
  value = mikrotik_dhcp_lease.leases
}
