# kubeconfig is generated via ansible-playbook
provider "kubernetes" {
  config_path    = "../../../node-b.hutter.cloud.kubeconfig"
}


provider "helm" {
  kubernetes {
    config_path    = "../../../node-b.hutter.cloud.kubeconfig"
  }
}

