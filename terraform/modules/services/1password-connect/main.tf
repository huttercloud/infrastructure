locals {
  annotations = {
    "nginx.ingress.kubernetes.io/ingress.class": "public"
  }
}


resource "helm_release" "onepassword_connect" {
  name = "1password-connect"

  repository = "https://1password.github.io/connect-helm-charts"
  chart      = "connect"
  version    = var.onepassword_connect_version


  set_sensitive {
    name  = "connect.credentials_base64"
    value = var.onepassword_connect_credentials
  }

  set {
    name  = "connect.ingress.enabled"
    value = true
  }

  set {
    name  = "connect.ingress.hosts[0].host"
    value = var.onepassword_connect_host
  }

  set {
    name  = "connect.ingress.ingressClassName"
    value = "public"
  }


  set {
    name = "connect.ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/ingress\\.class"
    value = "public"
  }

  set {
    name = "connect.ingress.annotations.cert-manager\\.io/cluster-issuer"
    value = "letsencrypt-dns"
  }

  set {
    name = "connect.ingress.tls[0].secretName"
    value = "onepassword-connect-tls"
  }

  set {
    name = "connect.ingress.tls[0].hosts[0]"
    value = var.onepassword_connect_host
  }

#   locals {
#     tls = [
#       {
#         hosts = [
#           var.onepassword_connect_host
#         ]
#       }
#     ]
#   }

#   set {
#     name = "connect.ingress.tls"
#     value = jsonencode(local.tls)
#   }



}
