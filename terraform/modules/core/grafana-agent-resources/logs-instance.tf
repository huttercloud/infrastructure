#
#
# TODO: move to argocd app!
#


resource "kubernetes_manifest" "logsinstance_primary" {
  manifest = {
    "apiVersion" = "monitoring.grafana.com/v1alpha1"
    "kind" = "LogsInstance"
    "metadata" = {
      "labels" = {
        "agent" = "grafana-agent-logs"
      }
      "name" = "primary"
      "namespace" = "default"
    }
    "spec" = {
      "podLogsNamespaceSelector" = {}
      "podLogsSelector" = {
        "matchLabels" = {
          "instance" = "primary"
        }
      }
      "clients" = [
        {
          "basicAuth" = {
            "password" = {
              "key" = "password"
              "name" = "grafana-agent-loki"
            }
            "username" = {
              "key" = "username"
              "name" = "grafana-agent-loki"
            }
          }
          # passing the url as secret is not possible so its passed via tf var and remote data source
          "url" = var.logs_url
          "externalLabels" = {
            "cluster" = var.cluster_name
          }
        },
      ]
    }
  }
}
