resource "kubernetes_manifest" "app_node_a" {
  manifest = {
    "apiVersion" = "argoproj.io/v1alpha1"
    "kind" = "Application"
    "metadata" = {
      "name" = "node-a"
      "namespace" = "default"
    }
    "spec" = {
      "syncPolicy" = {
        "automated" = {}
      }
      "destination" = {
        "server" = "https://node-b.hutter.cloud:16443" // the app of apps needs to be registered on the argocd server itself!
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