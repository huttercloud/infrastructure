resource "helm_release" "grafana_agent_operator" {
  name       = "grafana-agent-operator"

  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana-agent-operator"
  version    = var.grafana_agent_operator_version
}