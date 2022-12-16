resource "kubernetes_storage_class" "this" {
  metadata {
    name = var.storage_class_name
  }
  storage_provisioner = "microk8s.io/hostpath"
  reclaim_policy      = "Retain"
  parameters = {
    pvDir = var.storage_class_path
  }
}