resource "kubernetes_manifest" "app_node_a" {
  manifest = {
    "apiVersion" = "argoproj.io/v1alpha1"
    "kind" = "Application"
    "metadata" = {
      "name" = "node-a"
      "namespace" = "default"
    }
    "spec" = {
      "destination" = {
        "server" = "https://node-a.hutter.cloud:16443"
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