

resource "kubernetes_secret" "external_secrets" {
  metadata {
    name = "external-secrets"
    labels = {
      "app.kubernetes.io/name" = "external-secrets"
    }
  }

  data = {
    access-key = var.access_key_id_parameter_store
    secret-key = var.secret_access_key_parameter_store
  }
}


resource "kubernetes_manifest" "external_secrets_cluster_secret_store" {
  manifest = {
    "apiVersion" = "external-secrets.io/v1beta1"
    "kind"       = "ClusterSecretStore"
    "metadata" = {
      "name"      = "ssm"
    }
    "spec" = {
      "provider" = {
        "aws" = {
            "service" = "ParameterStore"
            "region" = "eu-central-1"
            "auth" = {
                "secretRef" = {
                    "accessKeyIDSecretRef" = {
                        "name" = kubernetes_secret.external_secrets.metadata.0.name
                        "namespace" = kubernetes_secret.external_secrets.metadata.0.namespace
                        "key" = "access-key"
                    }
                    "secretAccessKeySecretRef" = {
                        "name" = kubernetes_secret.external_secrets.metadata.0.name
                        "namespace" = kubernetes_secret.external_secrets.metadata.0.namespace
                        "key" = "secret-key"
                    }
                }
                }
            }
        }
      }
  }
}