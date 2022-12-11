locals {
    callbacks = [
        "https://hello-world/oauth2/callback"
    ]
}

resource "auth0_client" "oauth2_proxy" {
  name                                = "Oauth2 Proxy Client"
  description                         = "Allow"
  app_type                            = "non_interactive"
  custom_login_page_on                = true
  is_first_party                      = true
  is_token_endpoint_ip_header_trusted = true
  token_endpoint_auth_method          = "client_secret_post"
  oidc_conformant                     = false
  callbacks                           = local.callbacks
  grant_types = [
    "authorization_code",
    "http://auth0.com/oauth/grant-type/password-realm",
    "implicit",
    "password",
    "refresh_token"
  ]
}

output oauth2_proxy_client_id {
    value = auth0_client.oauth2_proxy.client_id
    sensitive = true
}

output oauth2_proxy_client_secret {
    value = auth0_client.oauth2_proxy.client_secret
    sensitive = true
}