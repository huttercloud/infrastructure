module "wireguard" {
  source = "../../../modules/services/wireguard"

  storage_class_name                 = module.storage_class_data.storage_class_name
  wireguard_version                  = local.wireguard_version
  wireguard_peers                    = local.wireguard_peers
  wireguard_serverurl                = local.wireguard_serverurl
  wireguard_internal_subnet          = local.wireguard_internal_subnet
  wireguard_peerdns                  = local.wireguard_peerdns
  wireguard_external_hostname_target = module.external_name_cronjob.external_name_target
}

module "pi_hole" {
  source = "../../../modules/services/pi-hole"

  storage_class_name  = module.storage_class_data.storage_class_name
  pi_hole_version     = local.pi_hole_version
  pi_hole_external_ip = local.pi_hole_external_ip
  pi_hole_hostname    = local.pi_hole_hostname 
}