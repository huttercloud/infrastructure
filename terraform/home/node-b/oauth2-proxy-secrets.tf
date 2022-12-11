resource "kubernetes_secret" "oauth2_proxy_secrets" {
  metadata {
    name = "oauth2-proxy-secrets"
  }


  data = {
    client_id     = data.terraform_remote_state.auth0.outputs.oauth2_proxy_client_id
    client_secret = data.terraform_remote_state.auth0.outputs.oauth2_proxy_client_secret
    # sharing the same cookie secret is a no go ... but its a home network so ... aeh
    cookie_secret = var.oauth2_proxy_cookie_secret
  }
}
