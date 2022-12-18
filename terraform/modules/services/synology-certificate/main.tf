# create a certificate and config scripts
# to auto update the synology nas certificate

resource "kubernetes_manifest" "synology_certificate_private_key" {
  manifest = {
    "apiVersion" = "external-secrets.io/v1beta1"
    "kind" = "ExternalSecret"
    "metadata" = {
      "name" = "synology-certificate-private-key"
      "namespace" = "default"
      "labels" = {
        "app.kubernetes.io/name" = "synology-certificate"
      }
    }
    "spec" = {
      "data" = [
        {
          "remoteRef" = {
            "key" = "hutter-cloud-service-synology-certificate-private-key"
          }
          "secretKey" = "privatekey"
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
            "private-key" = "{{ .privatekey }}"
          }
          "engineVersion" = "v2"
        }
      }
    }
  }
}

resource "kubernetes_manifest" "synology_certificate_cert" {
  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind" = "Certificate"
    "metadata" = {
      "name" = "synology-certificate-cert"
      "namespace" = "default"
      "labels" = {
        "app.kubernetes.io/name" = "synology-certificate"
      }
    }
    "spec" = {
      "secretName" = "synology-certificate-cert"
      "dnsNames" = [
        "nas.hutter.cloud"
      ]
      "issuerRef" = {
        "name" = "letsencrypt-dns"
        "kind" = "ClusterIssuer"
      }
    }
  }
}

resource "kubernetes_config_map" "synology_certificate_scripts" {
  metadata {
    name = "synology-certificate-scripts"
    labels = {
      "app.kubernetes.io/name" = "synology-certificate"
    }
  }

  data = {
    "script.sh" = <<EOT
#!/bin/sh
set -e

pip install --upgrade pip
pip install paramiko scp

exec python3 /script/synology-certificate.py
EOT
    "synology-certificate.py" = file("${path.module}/synology-certificate.py")
  }
}

resource "kubernetes_cron_job_v1" "synology_certificate" {
  metadata {
    name = "synology-certificate"
    labels = {
      "app.kubernetes.io/name" = "synology-certificate"
    }
  }

 spec {
   schedule = "@daily"
   concurrency_policy = "Forbid"
   job_template {
     metadata {}
     spec {
       backoff_limit = 2
       template {
         metadata {}
         spec {
           container {
            name = "python"
            image = "python:3"
            command = [ "/bin/sh", "/script/script.sh" ]
            volume_mount {
              name = "script"
              mount_path = "/script"
            }
            volume_mount {
              name = "certificate"
              mount_path = "/certificate"
            }
            volume_mount {
              name = "ssh-key"
              mount_path = "/ssh-key"
            }
           }
           volume {
             name = "script"
             config_map {
               name = kubernetes_config_map.synology_certificate_scripts.metadata.0.name
             }
           }
           volume {
             name = "certificate"
             secret {
               secret_name = "synology-certificate-cert"
             }
           }
           volume {
             name = "ssh-key"
             secret {
               secret_name = "synology-certificate-private-key"
             }
           }
          }
        }
      }
    }
  }
}