resource "kubernetes_secret" "oauth2_proxy_secrets" {
  metadata {
    name = "oauth2-proxy-secrets"
  }
  data = {
    client_id     = local.oauth2_proxy_client_id
    client_secret = local.oauth2_proxy_client_secret
    cookie_secret = local.oauth2_proxy_cookie_secret
  }
}
