
module "argo_cd" {
  source = "../../../modules/services/argo-cd"

  argo_cd_version = local.argo_cd_version
  argo_cd_host = local.argo_cd_host
  argo_cd_server_admin_password = var.argo_cd_server_admin_password
  argo_cd_auth0_issuer = local.argo_cd_auth0_issuer
  argo_cd_auth0_client_id = data.terraform_remote_state.auth0.outputs.argo_cd_client_id
  argo_cd_auth0_client_secret = data.terraform_remote_state.auth0.outputs.argo_cd_client_secret
}

module "argo_cd_declarative" {
  source = "../../../modules/services/argo-cd-declarative"
}