locals {
    # application versions
    external_dns_version = "v0.13.1"
    external_secrets_version = "0.7.0"
    grafana_agent_operator_version = "0.2.8"
    grafana_agent_version = "v0.29.0"
    argo_cd_version = "5.16.7"

    # cert manager configuration
    cert_manager_email = "huttersebastian@gmail.com"

    # externalname (cname record in aws) configuration
    externalname_hostname = "infra.hutter.cloud"

    # external dns configuration
    txt_owner_id="node-b-external-dns"

    # storage class configuration
    storage_class_name_data = "persistent"
    storage_class_path_data = "/data"

    # grafana configuration
    cluster_name = "node-b"

    # argo cd configuration
    argo_cd_host = "argocd.hutter.cloud"
    argo_cd_auth0_issuer = "https://hutter-cloud.eu.auth0.com/"
}
