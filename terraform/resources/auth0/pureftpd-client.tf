resource "auth0_client" "pureftpd" {
  name                                = "pureftpd.hutter.cloud"
  description                         = "Allow"
  app_type                            = "non_interactive"
  custom_login_page_on                = false
  is_first_party                      = true
  is_token_endpoint_ip_header_trusted = true
  token_endpoint_auth_method          = "client_secret_post"
  oidc_conformant                     = true
  grant_types = [
    "client_credentials",
    "password",
    "http://auth0.com/oauth/grant-type/password-realm",
  ]

  jwt_configuration {
    lifetime_in_seconds = 36000
    secret_encoded      = false
    alg                 = "RS256"
    scopes              = {}
  }
}

resource "auth0_resource_server" "pureftpd" {
  name        = "pureftpd.hutter.cloud"
  identifier  = "https://pureftpd.hutter.cloud"
  signing_alg = "RS256"

  allow_offline_access                            = false
  token_lifetime                                  = 8600
  skip_consent_for_verifiable_first_party_clients = true

}

resource "auth0_client_grant" "pureftpd" {
  client_id = auth0_client.pureftpd.id
  audience  = auth0_resource_server.pureftpd.identifier
  scope     = ["openid", "email", "profile"]
}

output "pureftpd_client_id" {
  value     = auth0_client.pureftpd.client_id
  sensitive = true
}

output "pureftpd_client_secret" {
  value     = auth0_client.pureftpd.client_secret
  sensitive = true
}

output "pureftpd_audience" {
    value = auth0_resource_server.pureftpd.identifier
}
