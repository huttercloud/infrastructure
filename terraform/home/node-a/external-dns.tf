resource "kubernetes_secret" "external_dns_aws" {
  metadata {
    name = "external-dns-aws"
    labels = {
      "app.kubernetes.io/name" = "external-dns"
    }
  }

  data = {
    credentials = <<EOT

[default]
aws_access_key_id = ${var.external_dns_aws_access_key_id}
aws_secret_access_key = ${var.external_dns_aws_secret_access_key}
EOT
  }
}

resource "kubernetes_secret" "external_dns_pi_hole" {
  metadata {
    name = "external-dns-pi-hole"
    labels = {
      "app.kubernetes.io/name" = "external-dns"
    }
  }

  data = {
    password = var.pi_hole_webpassword
  }
}



resource "kubernetes_service_account" "external_dns" {
  metadata {
    name = "external-dns"
    labels = {
      "app.kubernetes.io/name" = "external-dns"
    }
  }
}

resource "kubernetes_cluster_role" "external_dns" {
  metadata {
    name = "external-dns"
    labels = {
      "app.kubernetes.io/name" = "external-dns"
    }
  }

  rule {
    api_groups = [""]
    resources  = ["services", "endpoints", "pods", "nodes"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["extensions", "networking.k8s.io"]
    resources  = ["ingresses"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_cluster_role_binding" "external_dns" {
  metadata {
    name = "external-dns"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.external_dns.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.external_dns.metadata[0].name
    namespace = "default"
  }
}

locals {
  txt_owner_id="node-a-external-dns"
}

resource "kubernetes_deployment" "external_dns_aws" {
  metadata {
    name = "external-dns-aws"
    labels = {
      "app.kubernetes.io/name" = "external-dns-aws"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/name" = "external-dns-aws"
      }
    }

    strategy {
      type = "Recreate"
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/name" = "external-dns-aws"
        }
      }

      spec {
        service_account_name = kubernetes_service_account.external_dns.metadata[0].name
        automount_service_account_token = true
        container {
          image = "k8s.gcr.io/external-dns/external-dns:${local.external_dns_version}"
          name  = "external-dns"
          args = [
              "--source=service", # only create dns names for services with externalname and annotation due to no loadbalancer with public ip!
              "--domain-filter=hutter.cloud",
              "--provider=aws",
              "--policy=sync",
              "--aws-zone-type=public",
              "--registry=txt",
              "--txt-owner-id=${local.txt_owner_id}",
              "--txt-prefix=extdns",
              "--annotation-filter=hutter.cloud/dns-service in (aws)"
          ]
          env {
            name = "AWS_DEFAULT_REGION"
            value = "eu-central-1"
          }
          env {
            name = "AWS_SHARED_CREDENTIALS_FILE"
            value = "/secrets/credentials"
          }
          volume_mount {
            name = "aws-credentials"
            mount_path = "/secrets"
            read_only = true
          }
        }
        volume {
          name = "aws-credentials"
          secret {
            secret_name = kubernetes_secret.external_dns_aws.metadata[0].name
          }
        }
      }
    }
  }
}

