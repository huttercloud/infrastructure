resource "kubernetes_manifest" "cluster_issuer_aws" {
  manifest = {
    "apiVersion" = "external-secrets.io/v1beta1"
    "kind"       = "ExternalSecret"
    "metadata" = {
      "name"      = "cluster-issuer-aws"
      "namespace" = "cert-manager"
      "labels" = {
        "app.kubernetes.io/name" = "cluster-issuer"
      }
    }
    "spec" = {
      "data" = [
        {
          "remoteRef" = {
            "key" = "hutter-cloud-dns-access-key-id"
          }
          "secretKey" = "accesskey"
        },
        {
          "remoteRef" = {
            "key" = "hutter-cloud-dns-secret-access-key"
          }
          "secretKey" = "secretkey"
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
            "accessKey" = "{{ .accesskey }}"
            "secretKey" = "{{ .secretkey }}"
          }
          "engineVersion" = "v2"
        }
      }
    }
  }
}


resource "kubernetes_manifest" "cert_manager_cluster_issuer_dns" {
  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "ClusterIssuer"
    "metadata" = {
      "name" = "letsencrypt-dns"
    }
    spec = {
      acme = {
        email  = var.cert_manager_email
        server = "https://acme-v02.api.letsencrypt.org/directory"
        privateKeySecretRef = {
          name = "letsencrypt-dns-secret"
        }
        solvers = [{
          dns01 = {
            cnameStrategy = "Follow"
            route53 = {
              region = "eu-central-1"
              # not supported in microk8s cert-manager v1.8
              # accessKeyIDSecretRef = {
              #     name = "cluster-issuer-aws"
              #     key = "accessKey"
              # }
              accessKeyID = var.access_key_id_dns
              secretAccessKeySecretRef = {
                name = "cluster-issuer-aws"
                key  = "secretKey"
              }
            }

          }
        }]
      }
    }
  }
}
