

resource "kubernetes_secret" "cert_manager_cluster_issuer_dns" {
  metadata {
    name = "cluster-issuer-aws"
    namespace = "cert-manager"
  }

  data = {
    secret-access-key = var.external_dns_aws_secret_access_key
  }
} 

resource "kubernetes_manifest" "cert_manager_cluster_issuer_dns" {
  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "ClusterIssuer"
    "metadata" = {
      "name"      = "letsencrypt-dns"
    }
    spec = {
        acme = {
            email = local.cert_manager_email
            server = "https://acme-v02.api.letsencrypt.org/directory"
            privateKeySecretRef = {
                name = "letsencrypt-dns-secret"
            }
            solvers = [{
                dns01 = {
                    cnameStrategy = "Follow"
                    route53 = {
                        region = "eu-central-1"
                        accessKeyID = var.external_dns_aws_access_key_id
                        hostedZoneID = local.cert_manager_zone_id
                        secretAccessKeySecretRef = {
                            name = kubernetes_secret.cert_manager_cluster_issuer_dns.metadata[0].name
                            key = "secret-access-key"
                        }
                    }
                    
                }
            }]
        }
    }
  }
}

