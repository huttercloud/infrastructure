resource "kubernetes_manifest" "argo_cd_declarative_github_applicatons_deploy_key" {
  manifest = {
    "apiVersion" = "external-secrets.io/v1beta1"
    "kind" = "ExternalSecret"
    "metadata" = {
      "name" = "argo-cd-declarative-github-applications-repository"
      "namespace" = "default"
      "labels" = {
        "app.kubernetes.io/name" = "argo-cd-declarative"
      }
    }
    "spec" = {
      "data" = [
        {
          "remoteRef" = {
            "key" = "hutter-cloud-argo-cd-declarative-github-applications-deploy-key"
          }
          "secretKey" = "key"
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
                "argocd.argoproj.io/secret-type" = "repository"
            }
          }
          "data" = {
            "type" = "git"
            "url" = "git@github.com:huttercloud/applications.git"
            "sshPrivateKey" = "{{.key}}"
          }
          "engineVersion" = "v2"
        }
      }
    }
  }
}
