

##
# multimedia devices
##

locals {
  dhcp_leases = {
    # chromecast isnt in use anymore
    # "chromecast" = {
    #     macaddress = "80:D2:1D:01:55:96"
    #     address = "192.168.30.11"
    # },
    "apple-tv" = {
      macaddress = "AC:BC:32:64:8A:71"
      address    = "192.168.30.12"
    },
    "harmony-hub" = {
      macaddress = "00:04:20:EB:E9:8A"
      address    = "192.168.30.14"
    },
    "plex" = {
      macaddress = "14:98:77:3B:B0:D4"
      address    = "192.168.30.27"
    },
    "hdmi-switch-newschool" = {
      macaddress = "00:1C:91:04:C3:2F"
      address    = "192.168.30.31"
    },
    "hdmi-switch-oldschool" = {
      macaddress = "00:1C:91:04:C3:55"
      address    = "192.168.30.32"
    },
    "homeassistant" = {
      macaddress = "B8:27:EB:9B:65:33"
      address    = "192.168.30.182"
    },
    "nfs" = {
      macaddress = "00:11:32:87:1A:FD"
      address    = "192.168.30.17"
    },
    #uap isnt in use anymote
    # "uap" = {
    #     macaddress = "78:8A:20:DC:58:B1"
    #     address = "192.168.30.88"
    # },
    "printer" = {
      macaddress = "3C:2A:F4:47:86:7D"
      address    = "192.168.30.51"
    },
    "scanner" = {
      macaddress = "00:80:92:DA:EA:5C"
      address    = "192.168.30.52"
    },
    "node-a" = {
      macaddress = "EC:A8:6B:F9:87:92"
      address    = "192.168.30.61"
    },
    "node-b" = {
      macaddress = "2C:F0:5D:1F:FD:A6"
      address    = "192.168.30.90"
    },
    "node-c" = {
      macaddress = "EC:A8:6B:F5:A0:A1"
      address    = "192.168.30.39"
    },
    "synology" = {
      macaddress = "90:09:D0:25:32:E5"
      address    = "192.168.30.33"
    },
    "netgear-ap" = {
      macaddress = "94:18:65:41:21:39"
      address    = "192.168.30.48"
    },
    "laptop-lan" = {
      macaddress = "34:99:71:DE:E5:A6"
      address    = "192.168.30.28"
    },
    "laptop-wlan" = {
      macaddress = "BC:D0:74:7B:25:A8"
      address    = "192.168.30.36"
    },
    "playstation4" = {
      macaddress = "00:D9:D1:39:C1:A9"
      address    = "192.168.30.19"
    },
    "phonesebi" = {
      macaddress = "96:47:4A:AC:82:FB"
      address    = "192.168.30.20"
    },
    "phonekatha" = {
      macaddress = "D6:73:33:9A:FA:AC"
      address    = "192.168.30.192"
    },
    "pckatha" = {
      macaddress = "2C:F0:5D:1F:FD:99"
      address    = "192.168.30.25"
    },
    "playstation5" = {
      macaddress = "5C:84:3C:A3:A5:B5"
      address    = "192.168.30.196"
    },
    "netgeargs108ev3" = {
      macaddress = "CC:40:D0:3E:38:26"
      address    = "192.168.30.37"
    },
    "nintendoswitch" = {
      macaddress = "98:B6:E9:B9:A9:70"
      address    = "192.168.30.38"
    },
  }
}


resource "mikrotik_dhcp_lease" "leases" {
  for_each = local.dhcp_leases

  address    = each.value.address
  macaddress = each.value.macaddress
  # the comment is re-used by the pi-hole resource to create A records!
  comment = "${each.key}.hutter.cloud"
  blocked = "false"
}

output "dhcp_leases" {
  value = mikrotik_dhcp_lease.leases
}
