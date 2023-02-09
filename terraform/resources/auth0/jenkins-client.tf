locals {
  jenkins_callbacks = [
    "https://jenkins.hutter.cloud/securityRealm/finishLogin",
  ]
}

resource "auth0_client" "jenkins" {
  name                                = "jenkins.hutter.cloud"
  description                         = "Allow"
  app_type                            = "non_interactive"
  custom_login_page_on                = true
  is_first_party                      = true
  is_token_endpoint_ip_header_trusted = true
  token_endpoint_auth_method          = "client_secret_post"
  oidc_conformant                     = true
  callbacks                           = local.jenkins_callbacks
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

output "jenkins_client_id" {
  value     = auth0_client.jenkins.client_id
  sensitive = true
}

output "jenkins_client_secret" {
  value     = auth0_client.jenkins.client_secret
  sensitive = true
}
