resource "kubernetes_manifest" "oauth2_proxy_secrets" {
  manifest = {
    "apiVersion" = "external-secrets.io/v1beta1"
    "kind" = "ExternalSecret"
    "metadata" = {
      "name" = "oauth2-proxy-secrets"
      "namespace" = "default"
    }
    "spec" = {
      "data" = [
        {
          "remoteRef" = {
            "key" = "hutter-cloud-service-oauth2-proxy-client-id"
          }
          "secretKey" = "clientid"
        },
        {
          "remoteRef" = {
            "key" = "hutter-cloud-service-oauth2-proxy-client-secret"
          }
          "secretKey" = "clientsecret"
        },
        {
          "remoteRef" = {
            "key" = "hutter-cloud-service-oauth2-proxy-cookie-secret"
          }
          "secretKey" = "cookiesecret"
        },
      ]
      "refreshInterval" = "5m"
      "secretStoreRef" = {
        "kind" = "ClusterSecretStore"
        "name" = "ssm"
      }
      "target" = {
        "template" = {
          "data" = {
            "client_id" = "{{ .clientid }}"
            "client_secret" = "{{ .clientsecret }}"
            "cookie_secret" = "{{ .cookiesecret }}"
          }
          "engineVersion" = "v2"
        }
      }
    }
  }
}
