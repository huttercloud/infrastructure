locals {
    # aws credentials for dns
    access_key_id_dns = data.terraform_remote_state.aws-root-global.outputs.user_dns_access_key_id
    secret_access_key_dns = data.terraform_remote_state.aws-root-global.outputs.user_dns_secret_access_key
    # aws credentials for parameter store    
    access_key_id_parameter_store = data.terraform_remote_state.aws-root-global.outputs.user_parameter_store_access_key_id
    secret_access_key_parameter_store = data.terraform_remote_state.aws-root-global.outputs.user_parameter_store_secret_access_key

    # auth0 credentials for ouath2-proxy
    oauth2_proxy_client_id = data.terraform_remote_state.auth0.outputs.oauth2_proxy_client_id
    oauth2_proxy_client_secret = data.terraform_remote_state.auth0.outputs.oauth2_proxy_client_secret
    oauth2_proxy_cookie_secret = var.oauth2_proxy_cookie_secret

    # application versions
    external_dns_version = "v0.13.1"
    external_secrets_version = "0.7.0"
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