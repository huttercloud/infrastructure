resource "kubernetes_manifest" "metricsinstance_primary" {
  manifest = {
    "apiVersion" = "monitoring.grafana.com/v1alpha1"
    "kind" = "MetricsInstance"
    "metadata" = {
      "labels" = {
        "agent" = "grafana-agent-metrics"
      }
      "name" = "primary"
      "namespace" = "default"
    }
    "spec" = {
      "podMonitorNamespaceSelector" = {}
      "podMonitorSelector" = {
        "matchLabels" = {
          "instance" = "primary"
        }
      }
      "probeNamespaceSelector" = {}
      "probeSelector" = {
        "matchLabels" = {
          "instance" = "primary"
        }
      }
      "remoteWrite" = [
        {
          "basicAuth" = {
            "password" = {
              "key" = "password"
              "name" = "grafana-agent-prometheus"
            }
            "username" = {
              "key" = "username"
              "name" = "grafana-agent-prometheus"
            }
          }
          # passing the url as secret is not possible so its passed via tf var and remote data source 
          "url" = var.prometheus_remote_write_endpoint 
        },
      ]
      "serviceMonitorNamespaceSelector" = {}
      "serviceMonitorSelector" = {
        "matchLabels" = {
          "instance" = "primary"
        }
      }
    }
  }
}
