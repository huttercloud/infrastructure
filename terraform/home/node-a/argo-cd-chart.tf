
# resource "helm_release" "argo_cd" {
#   name       = "argo-cd"

#   repository = "https://argoproj.github.io/argo-helm"
#   chart      = "argo-cd"

#   set {
#     name  = "server.ingress.enabled"
#     value = true
#   }
#   set {
#     name  = "server.ingress.hosts"
#     value = "argocd.hutter.cloud"
#   }
# }