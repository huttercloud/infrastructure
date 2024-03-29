resource "helm_release" "external_secrets" {
  name = "external-secrets"

  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets"
  version    = var.external_secrets_version


  set {
    name  = "installCRDs"
    value = true
  }
}