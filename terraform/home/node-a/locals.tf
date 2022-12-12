locals {
    # aws iam access key id for dns access
    # v1.8 of cert manager (provided by microk8s) doesnt support "accessKeyIDSecretRef" in the spec of the dns
    # resolver, so we need to still reference the value as accessKeyID 
    access_key_id_dns = data.terraform_remote_state.aws-root-global.outputs.user_dns_access_key_id
     
    # aws credentials for cluster secret store   
    access_key_id_parameter_store = data.terraform_remote_state.aws-root-global.outputs.user_parameter_store_access_key_id
    secret_access_key_parameter_store = data.terraform_remote_state.aws-root-global.outputs.user_parameter_store_secret_access_key

    # application versions
    external_dns_version = "v0.13.1"
    external_secrets_version = "0.7.0"
    pi_hole_version = "2022.11.2"
    wireguard_version = "1.0.20210914"

    # pihole configuration
    pi_hole_external_ip = "192.168.30.253"

    # cert manager configuration
    cert_manager_email = "huttersebastian@gmail.com"

    # externalname (cname record in aws) configuration
    externalname_hostname = "infra.hutter.cloud"
}