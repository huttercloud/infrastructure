locals {
  # application versions
  external_dns_version           = "v0.13.5"
  external_secrets_version       = "0.15.0"
  pi_hole_version                = "2025.02.6"
  wireguard_version              = "1.0.20210914"
  unifi_version                  = "8.0.24"
  onepassword_connect_version    = "1.17.0"

  # cert manager configuration
  cert_manager_email = "huttersebastian@gmail.com"

  # external dns configuration
  txt_owner_id = "node-a-external-dns"

  # storage class configuration
  storage_class_name_data = "persistent"
  storage_class_path_data = "/data"

  # pihole configuration
  pi_hole_external_ip = "192.168.30.253"
  pi_hole_hostname    = "pihole.hutter.cloud"

  # wireguard configuration
  wireguard_peers                    = "mac,katharinamb,sebastianmb,test"
  wireguard_serverurl                = "wireguard.hutter.cloud"
  wireguard_external_hostname_target = "infra.hutter.cloud" # used by ext-dns service to create name alias
  wireguard_internal_subnet          = "192.168.130.0/24"
  wireguard_peerdns                  = "192.168.30.253"
  wireguard_external_ip              = "192.168.30.253"

  # unifi configuration
  unifi_external_ip = "192.168.30.253"
  unifi_hostname    = "unifi.hutter.cloud"

  # 1password-connect configuration
  onepassword_host = "1password-connect.hutter.cloud"

}

