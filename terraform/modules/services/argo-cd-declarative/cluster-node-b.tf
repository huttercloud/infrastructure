resource "kubernetes_manifest" "argo_cd_declarative_cluster_node_b" {
  manifest = {
    "apiVersion" = "external-secrets.io/v1beta1"
    "kind" = "ExternalSecret"
    "metadata" = {
      "name" = "argo-cd-declarative-cluster-node-b"
      "namespace" = "default"
      "labels" = {
        "app.kubernetes.io/name" = "argo-cd-declarative"
      }
    }
    "spec" = {
      "data" = [
        {
          "remoteRef" = {
            "key" = "hutter-cloud-argo-cd-declarative-kubernetes-host-node-b"
          }
          "secretKey" = "server"
        },
        {
          "remoteRef" = {
            "key" = "hutter-cloud-argo-cd-declarative-kubernetes-token-node-b"
          }
          "secretKey" = "token"
        },
        {
          "remoteRef" = {
            "key" = "hutter-cloud-argo-cd-declarative-kubernetes-cluster-ca-cert-data-node-b"
          }
          "secretKey" = "ca"
        },
      ]
      "refreshInterval" = "5m"
      "secretStoreRef" = {
        "kind" = "ClusterSecretStore"
        "name" = "ssm"
      }
      "target" = {
        "template" = {
          "metadata" = {
            "labels" = {
                "argocd.argoproj.io/secret-type" = "cluster"
            }
          }
          "data" = {
            "name" = "node-b.hutter.cloud"
            "server" = "{{ .server }}"
            "config" = <<EOT
            {
                "bearerToken": "{{ .token }}",
                "tlsClientConfig": {
                    "insecure": false,
                    "caData": "{{ .ca }}"
                }
            }
            EOT
          }
          "engineVersion" = "v2"
        }
      }
    }
  }
}
