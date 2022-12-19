resource "kubernetes_manifest" "argo_cd_declarative_cluster_node_a" {
  manifest = {
    "apiVersion" = "external-secrets.io/v1beta1"
    "kind" = "ExternalSecret"
    "metadata" = {
      "name" = "argo-cd-declarative-cluster-node-a"
      "namespace" = "default"
      "labels" = {
        "app.kubernetes.io/name" = "argo-cd-declarative"
      }
    }
    "spec" = {
      "data" = [
        {
          "remoteRef" = {
            "key" = "hutter-cloud-argo-cd-declarative-kubernetes-host-node-a"
          }
          "secretKey" = "server"
        },
        {
          "remoteRef" = {
            "key" = "hutter-cloud-argo-cd-declarative-kubernetes-token-node-a"
          }
          "secretKey" = "token"
        },
        {
          "remoteRef" = {
            "key" = "hutter-cloud-argo-cd-declarative-kubernetes-cluster-ca-cert-data-node-a"
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
            "name" = "node-a.hutter.cloud"
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
