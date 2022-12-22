resource "kubernetes_manifest" "external_secrets" {
  manifest = {
    "apiVersion" = "external-secrets.io/v1beta1"
    "kind"       = "ExternalSecret"
    "metadata" = {
      "name"      = "external-dns"
      "namespace" = "default"
      "labels" = {
        "app.kubernetes.io/name" = "external-dns"
      }
    }
    "spec" = {
      "data" = [
        {
          "remoteRef" = {
            "key" = "hutter-cloud-dns-zone-id"
          }
          "secretKey" = "zoneid"
        },
        {
          "remoteRef" = {
            "key" = "hutter-cloud-dns-access-key-id"
          }
          "secretKey" = "accesskey"
        },
        {
          "remoteRef" = {
            "key" = "hutter-cloud-dns-secret-access-key"
          }
          "secretKey" = "secretkey"
        },
        {
          "remoteRef" = {
            "key" = "hutter-cloud-service-pihole-web-password"
          }
          "secretKey" = "pihole"
        },
      ]
      "refreshInterval" = "5m"
      "secretStoreRef" = {
        "kind" = "ClusterSecretStore"
        "name" = "ssm"
      }
      "target" = {
        "template" = {
          "data" = {
            "aws"    = <<EOT
            [default]
            aws_access_key_id = {{ .accesskey }}
            aws_secret_access_key = {{ .secretkey }}
            
            EOT
            "zoneId" = "{{ .zoneid }}"
            "pihole" = "{{ .pihole }}"
          }
          "engineVersion" = "v2"
        }
      }
    }
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
        service_account_name            = kubernetes_service_account.external_dns.metadata[0].name
        automount_service_account_token = true
        container {
          image = "k8s.gcr.io/external-dns/external-dns:${var.external_dns_version}"
          name  = "external-dns"
          args = [
            "--source=service", # only create dns names for services with externalname and annotation due to no loadbalancer with public ip!
            "--domain-filter=hutter.cloud",
            "--provider=aws",
            "--policy=sync",
            "--aws-zone-type=public",
            "--registry=txt",
            "--txt-owner-id=${var.txt_owner_id}",
            "--txt-prefix=extdns",
            "--annotation-filter=hutter.cloud/dns-service in (aws)"
          ]
          env {
            name  = "AWS_DEFAULT_REGION"
            value = "eu-central-1"
          }
          env {
            name  = "AWS_SHARED_CREDENTIALS_FILE"
            value = "/secrets/aws"
          }
          volume_mount {
            name       = "aws-credentials"
            mount_path = "/secrets"
            read_only  = true
          }
        }
        volume {
          name = "aws-credentials"
          secret {
            # secret is created via external-secretsad
            secret_name = "external-dns"
          }
        }
      }
    }
  }
}

