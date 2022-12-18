resource "helm_release" "argo_cd" {
  name       = "argo-cd"

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.argo_cd_version

  # configure base url
  set {
    name  = "configs.cm.url"
    value = "https://${var.argo_cd_host}"
  }

  # set default admin password
  set_sensitive {
    name  = "configs.secret.argocdServerAdminPassword"
    value = var.argo_cd_server_admin_password
  }

  # setup auth0 as login, all auth0 users have r/w permissions, auth0 free plan doesnt know groups!
  set {
    name  = "configs.cm.oidc\\.config"
    value = <<EOT
name: Auth0
issuer: ${var.argo_cd_auth0_issuer}
clientID: ${var.argo_cd_auth0_client_id}
clientSecret: ${var.argo_cd_auth0_client_secret}
requestedScopes:
  - openid
  - profile
  - email
EOT
}

  set {
    name = "configs.rbac.policy\\.default"
    value = "role:admin"
  }

  #  configure server certificate with letsencrypt
  set {
    name = "server.certificate.enabled"
    value = true
  }

  set {
    name = "server.certificate.secretName"
    value = "argocd-server-tls"
  }

  set {
    name = "server.certificate.domain"
    value = var.argo_cd_host
  }

  set {
    name = "server.certificate.issuer.kind"
    value = "ClusterIssuer"
  }

  set {
    name = "server.certificate.issuer.name"
    value = "letsencrypt-dns"
  }



  # configure ingress with https passthrough (have ui and grpc with the same hostname)
  set {
    name  = "server.ingress.enabled"
    value = true
  }
  set {
    name  = "server.ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/ingress\\.class"
    value = "public"
  }
  set {
    name  = "server.ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/ssl-redirect"
    value = true
  }
  set {
    name  = "server.ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/ssl-passthrough"
    value = true
  }
  set {
    name  = "server.ingress.ingressClassName"
    value = "public"
  }
  set {
    name  = "server.ingress.hosts[0]"
    value = var.argo_cd_host
  }



  
}
