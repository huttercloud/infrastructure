resource "kubernetes_manifest" "grafana_agent_prometheus_secret" {
  manifest = {
    "apiVersion" = "external-secrets.io/v1beta1"
    "kind" = "ExternalSecret"
    "metadata" = {
      "name" = "grafana-agent-prometheus"
      "namespace" = "default"
      "labels" = {
        "app.kubernetes.io/name" = "grafana-agent"
      }
    }
    "spec" = {
      "data" = [
        {
          "remoteRef" = {
            "key" = "hutter-cloud-grafana-prometheus-remote-endpoint-user-id"
          }
          "secretKey" = "userid"
        },
        {
          "remoteRef" = {
            "key" = "hutter-cloud-grafana-prometheus-remote-endpoint-user-key"
          }
          "secretKey" = "userkey"
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
            "username" = "{{ .userid }}"
            "password" = "{{ .userkey }}"
          }
          "engineVersion" = "v2"
        }
      }
    }
  }
}

resource "kubernetes_manifest" "grafana_agent_loki_secret" {
  manifest = {
    "apiVersion" = "external-secrets.io/v1beta1"
    "kind" = "ExternalSecret"
    "metadata" = {
      "name" = "grafana-agent-loki"
      "namespace" = "default"
      "labels" = {
        "app.kubernetes.io/name" = "grafana-agent"
      }
    }
    "spec" = {
      "data" = [
        {
          "remoteRef" = {
            "key" = "hutter-cloud-grafana-logs-user-id"
          }
          "secretKey" = "userid"
        },
        {
          "remoteRef" = {
            "key" = "hutter-cloud-grafana-logs-user-key"
          }
          "secretKey" = "userkey"
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
            "username" = "{{ .userid }}"
            "password" = "{{ .userkey }}"
          }
          "engineVersion" = "v2"
        }
      }
    }
  }
}

