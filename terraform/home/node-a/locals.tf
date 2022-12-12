locals {
    # aws credentials
    access_key_id_dns = data.terraform_remote_state.aws-root-global.outputs.user_dns_access_key_id
    secret_access_key_dns = data.terraform_remote_state.aws-root-global.outputs.user_dns_secret_access_key
    
    # application versions
    external_dns_version = "v0.13.1"
    pi_hole_version = "2022.11.2"
    wireguard_version = "1.0.20210914"

    # pihole configuration
    pi_hole_external_ip = "192.168.30.253"

    # cert manager configuration
    cert_manager_email = "huttersebastian@gmail.com"
    cert_manager_zone_id = data.terraform_remote_state.aws-root-global.outputs.hutter_cloud_zone_id

    # externalname (cname record in aws) configuration
    externalname_hostname = "infra.hutter.cloud"
    externalname_zone_id = data.terraform_remote_state.aws-root-global.outputs.hutter_cloud_zone_id
}