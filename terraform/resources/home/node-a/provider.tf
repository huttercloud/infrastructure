# kubeconfig is generated via ansible-playbook
provider "kubernetes" {
  config_path    = "../../../node-a.hutter.cloud.kubeconfig"
}

provider "helm" {
  kubernetes {
    config_path    = "../../../node-a.hutter.cloud.kubeconfig"
  }
}

