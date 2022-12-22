locals {
  argo_cd_callbacks = [
    "https://argocd.hutter.cloud/auth/callback"
  ]
}

resource "auth0_client" "argo_cd" {
  name                                = "argocd.hutter.cloud"
  description                         = "Allow"
  app_type                            = "non_interactive"
  custom_login_page_on                = true
  is_first_party                      = true
  is_token_endpoint_ip_header_trusted = true
  token_endpoint_auth_method          = "client_secret_post"
  oidc_conformant                     = true
  callbacks                           = local.argo_cd_callbacks
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

output "argo_cd_client_id" {
  value     = auth0_client.argo_cd.client_id
  sensitive = true
}

output "argo_cd_client_secret" {
  value     = auth0_client.argo_cd.client_secret
  sensitive = true
}
