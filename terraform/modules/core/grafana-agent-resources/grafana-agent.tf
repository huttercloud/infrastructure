#
#
# TODO: move to argocd app!
#



resource "kubernetes_service_account" "grafana_agent" {
  metadata {
    name = "grafana-agent"
    labels = {
      app = "grafana-agent"
    }
  }
}

resource "kubernetes_cluster_role" "grafana_agent" {
  metadata {
    name = "grafana-agent"
    labels = {
      app = "grafana-agent"
    }
  }

  rule {
    api_groups = [""]
    resources = [
      "nodes",
      "nodes/proxy",
      "nodes/metrics",
      "services",
      "endpoints",
      "pods",
      "events",
    ]
    verbs = [
      "get",
      "list",
      "watch",
    ]
  }

  rule {
    api_groups = ["networking.k8s.io"]
    resources = [
      "ingresses",
    ]
    verbs = [
      "get",
      "list",
      "watch",
    ]
  }

  rule {
    non_resource_urls = [
      "/metrics",
      "/metrics/cadvisor",
    ]
    verbs = [
      "get",
    ]
  }
}

resource "kubernetes_cluster_role_binding" "grafana_agent" {
  metadata {
    name = "grafana-agent"
    labels = {
      app = "grafana-agent"
    }
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind = "ClusterRole"
    name = kubernetes_cluster_role.grafana_agent.metadata.0.name
  }

  subject {
    kind = "ServiceAccount"
    name = kubernetes_service_account.grafana_agent.metadata.0.name
    namespace = kubernetes_service_account.grafana_agent.metadata.0.namespace
  }
}

resource "kubernetes_manifest" "grafana_agent" {
  manifest = {
    "apiVersion" = "monitoring.grafana.com/v1alpha1"
    "kind" = "GrafanaAgent"
    "metadata" = {
      "labels" = {
        "app" = "grafana-agent"
      }
      "name" = "grafana-agent"
      "namespace" = "default"
    }
    "spec" = {
      "image" = "grafana/agent:${var.grafana_agent_version}"
      "logLevel" = "info"
      "logs" = {
        "instanceSelector" = {
          "matchLabels" = {
            "agent" = "grafana-agent-logs"
          }
        }
      }
      "metrics" = {
        "externalLabels" = {
          "cluster" = var.cluster_name
        }
        "instanceSelector" = {
          "matchLabels" = {
            "agent" = "grafana-agent-metrics"
          }
        }
      }
      "serviceAccountName" = kubernetes_service_account.grafana_agent.metadata.0.name
    }
  }
}
