resource "kubernetes_manifest" "podlogs" {
  manifest = {
    "apiVersion" = "monitoring.grafana.com/v1alpha1"
    "kind" = "PodLogs"
    "metadata" = {
      "labels" = {
        "instance" = "primary"
      }
      "name" = "pod-logs"
      "namespace" = "default"
    }
    "spec" = {
      "pipelineStages" = [
        {
          "docker" = {}
        },
      ]
      "namespaceSelector" = {
        "matchNames" = [
          "cert-manager",
          "default",
          "ingress"
        ]
      }
      "selector" = {
        "matchLabels" = {}
      }
    }
  }
}