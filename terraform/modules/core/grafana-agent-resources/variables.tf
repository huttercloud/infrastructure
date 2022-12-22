#
#
# TODO: move to argocd app!
#



variable "grafana_agent_version" {
  type = string
}

variable "prometheus_remote_write_endpoint" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "logs_url" {
  type = string
}
