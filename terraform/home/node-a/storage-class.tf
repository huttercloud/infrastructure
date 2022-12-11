resource "kubernetes_storage_class" "persistent" {
  metadata {
    name = "persistent"
  }
  storage_provisioner = "microk8s.io/hostpath"
  reclaim_policy      = "Retain"
  parameters = {
    pvDir = "/data"
  }
}