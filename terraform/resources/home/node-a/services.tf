
# wireguard has been moved to mikrotik router

# module "wireguard" {
#   source = "../../../modules/services/wireguard"

#   storage_class_name                 = module.storage_class_data.storage_class_name
#   wireguard_version                  = local.wireguard_version
#   wireguard_external_ip              = local.wireguard_external_ip
#   wireguard_peers                    = local.wireguard_peers
#   wireguard_serverurl                = local.wireguard_serverurl
#   wireguard_internal_subnet          = local.wireguard_internal_subnet
#   wireguard_peerdns                  = local.wireguard_peerdns
#   wireguard_external_hostname_target = local.wireguard_external_hostname_target
# }

# pihole is running on digitalocean droplet

# module "pi_hole" {
#   source = "../../../modules/services/pi-hole"

#   storage_class_name  = module.storage_class_data.storage_class_name
#   pi_hole_version     = local.pi_hole_version
#   pi_hole_external_ip = local.pi_hole_external_ip
#   pi_hole_hostname    = local.pi_hole_hostname
# }


# unifi ap not in use anymore

# module "unifi" {
#   source = "../../../modules/services/unifi"

#   storage_class_name = module.storage_class_data.storage_class_name
#   unifi_version      = local.unifi_version
#   unifi_external_ip  = local.unifi_external_ip
#   unifi_hostname     = local.unifi_hostname
# }

# 1password connect is running on digitalocean droplet

# module "onepassword-connect" {
#   source = "../../../modules/services/1password-connect"

#   onepassword_connect_version = local.onepassword_connect_version
#   onepassword_connect_host = local.onepassword_host
#   onepassword_connect_credentials = var.onepassword_connect_credentials
# }
