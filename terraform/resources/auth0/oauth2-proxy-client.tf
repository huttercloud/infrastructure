locals {
  oauth2_proxy_callbacks = [
    "https://hello-world.hutter.cloud/oauth2/callback",
    "https://usenet.hutter.cloud/oauth2/callback",
    "https://grafana.hutter.cloud/oauth2/callback",
    "https://prometheus.hutter.cloud/oauth2/callback",
    "https://tautulli.hutter.cloud/oauth2/callback",
    "https://overseerr.hutter.cloud/oauth2/callback",
    "https://calibre.hutter.cloud/oauth2/callback",
    "https://calibre-content.hutter.cloud/oauth2/callback",
  ]
}

resource "auth0_client" "oauth2_proxy" {
  name                                = "hutter.cloud"
  description                         = "Allow"
  app_type                            = "non_interactive"
  custom_login_page_on                = true
  is_first_party                      = true
  is_token_endpoint_ip_header_trusted = true
  token_endpoint_auth_method          = "client_secret_post"
  oidc_conformant                     = true
  callbacks                           = local.oauth2_proxy_callbacks
  grant_types = [
    "authorization_code",
    "http://auth0.com/oauth/grant-type/password-realm",
    "implicit",
    "password",
    "refresh_token"
  ]

  jwt_configuration {
    lifetime_in_seconds = 36000
    secret_encoded      = false
    alg                 = "RS256"
    scopes              = {}
  }
}

output "oauth2_proxy_client_id" {
  value     = auth0_client.oauth2_proxy.client_id
  sensitive = true
}

output "oauth2_proxy_client_secret" {
  value     = auth0_client.oauth2_proxy.client_secret
  sensitive = true
}
