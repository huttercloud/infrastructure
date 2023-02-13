# argo cd declarative setup
resource "aws_ssm_parameter" "hutter_cloud_argo_cd_declarative_kubernetes_host_node_a" {
  name  = "hutter-cloud-argo-cd-declarative-kubernetes-host-node-a"
  type  = "SecureString"
  value = local.secrets.argocd.nodea.host
}

resource "aws_ssm_parameter" "hutter_cloud_argo_cd_declarative_kubernetes_token_node_a" {
  name  = "hutter-cloud-argo-cd-declarative-kubernetes-token-node-a"
  type  = "SecureString"
  value = local.secrets.argocd.nodea.token
}

resource "aws_ssm_parameter" "hutter_cloud_argo_cd_declarative_kubernetes_cluster_ca_cert_data_node_a" {
  name  = "hutter-cloud-argo-cd-declarative-kubernetes-cluster-ca-cert-data-node-a"
  type  = "SecureString"
  value = local.secrets.argocd.nodea.cert
}

resource "aws_ssm_parameter" "hutter_cloud_argo_cd_declarative_kubernetes_host_node_b" {
  name  = "hutter-cloud-argo-cd-declarative-kubernetes-host-node-b"
  type  = "SecureString"
  value = local.secrets.argocd.nodeb.host
}

resource "aws_ssm_parameter" "hutter_cloud_argo_cd_declarative_kubernetes_token_node_b" {
  name  = "hutter-cloud-argo-cd-declarative-kubernetes-token-node-b"
  type  = "SecureString"
  value = local.secrets.argocd.nodeb.token
}

resource "aws_ssm_parameter" "hutter_cloud_argo_cd_declarative_kubernetes_cluster_ca_cert_data_node_b" {
  name  = "hutter-cloud-argo-cd-declarative-kubernetes-cluster-ca-cert-data-node-b"
  type  = "SecureString"
  value = local.secrets.argocd.nodeb.cert
}

resource "aws_ssm_parameter" "hutter_cloud_argo_cd_declarative_github_applications_deploy_key" {
  name  = "hutter-cloud-argo-cd-declarative-github-applications-deploy-key"
  type  = "SecureString"
  value = base64decode(local.secrets.argocd.github.deploykey)
}
