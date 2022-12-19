// https://github.com/argoproj/argo-cd/blob/master/docs/operator-manual/application.yaml

resource "kubernetes_manifest" "app_node_b" {
  manifest = {
    "apiVersion" = "argoproj.io/v1alpha1"
    "kind" = "Application"
    "metadata" = {
      "name" = "node-b"
      "namespace" = "default"
    }
    "spec" = {
      "destination" = {
        "server" = "https://node-b.hutter.cloud:16443"
      }
      "project" = "default"
      "source" = {
        "path" = "applications/node-a"
        "repoURL" = "git@github.com:huttercloud/applications.git"
        "targetRevision" = "HEAD"
      }
    }
  }
}