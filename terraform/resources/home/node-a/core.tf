# 
# install core applications in k8s
# 


locals {
    # aws iam access key id for dns access
    # v1.8 of cert manager (provided by microk8s) doesnt support "accessKeyIDSecretRef" in the spec of the dns
    # resolver, so we need to still reference the value as accessKeyID 
    core_access_key_id_dns = data.terraform_remote_state.aws-root-global.outputs.user_dns_access_key_id
     
    # aws credentials for cluster secret store   
    core_access_key_id_parameter_store = data.terraform_remote_state.aws-root-global.outputs.user_parameter_store_access_key_id
    core_secret_access_key_parameter_store = data.terraform_remote_state.aws-root-global.outputs.user_parameter_store_secret_access_key

    # prometheus remote write endpoint
    core_prometheus_remote_write_endpoint = data.terraform_remote_state.grafana.outputs.prometheus_remote_write_endpoint
    core_logs_url = "${data.terraform_remote_state.grafana.outputs.logs_url}/loki/api/v1/push"
}


module "cluster_issuer" {
  source = "../../../modules/core/cluster-issuer"

  access_key_id_dns = local.core_access_key_id_dns
  cert_manager_email = local.cert_manager_email
}

module "external_dns" {
  source = "../../../modules/core/external-dns"

  external_dns_version = local.external_dns_version
  txt_owner_id = local.txt_owner_id
}

module "external_secrets" {
  source = "../../../modules/core/external-secrets"

  external_secrets_version = local.external_secrets_version
}

module "secret_stores" {
  source = "../../../modules/core/secret-stores"

  access_key_id_parameter_store = local.core_access_key_id_parameter_store
  secret_access_key_parameter_store = local.core_secret_access_key_parameter_store
}

module "storage_class_data" {
    source = "../../../modules/core/storage-class-hostpath"
    
    storage_class_name = local.storage_class_name_data
    storage_class_path = local.storage_class_path_data
}

# module "grafana_agent_operator" {
#   source = "../../../modules/core/grafana-agent-operator"

#   grafana_agent_operator_version = local.grafana_agent_operator_version
# }

# module "grafana_agent_resources" {
#   source = "../../../modules/core/grafana-agent-resources"

#   cluster_name = local.cluster_name
#   grafana_agent_version = local.grafana_agent_version
#   prometheus_remote_write_endpoint = local.core_prometheus_remote_write_endpoint
#   logs_url = local.core_logs_url
# }