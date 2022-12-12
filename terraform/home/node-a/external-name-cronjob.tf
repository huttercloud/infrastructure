# update the dns entry infra.hutter.cloud regularly

resource "kubernetes_config_map" "externalname" {
  metadata {
    name = "externalname"
    labels = {
      "app.kubernetes.io/name" = "externalname"
    }
  }

  data = {
    "script.sh"             = <<EOT
#!/bin/sh
set -e

public_ip=$(curl --silent ifconfig.co)
[ -z "$${public_ip}" ] && echo unable to retrieve ip, aborting. && exit 1
echo upsert entry for home.hutter.cloud to $public_ip
sed "s/IPADDRESS/$${public_ip}/g" /script/upsert.json > /tmp/upsert.json

aws route53 change-resource-record-sets --hosted-zone-id $${HOSTED_ZONE_ID} --change-batch file:///tmp/upsert.json
EOT
    "upsert.json"             = <<EOT
{
    "Comment": "Set public ip",
    "Changes": [
        {
            "Action": "UPSERT",
            "ResourceRecordSet": {
            "Name": "${local.externalname_hostname}",
            "Type": "A",
            "TTL": 300,
            "ResourceRecords": [
                { 
                "Value": "IPADDRESS"
                }
            ]
            }
        }
    ]
}

EOT
  }
}

resource "kubernetes_cron_job_v1" "externalname" {
  metadata {
    name = "externalname"
    labels = {
      "app.kubernetes.io/name" = "externalname"
    }
  }

 spec {
   schedule = "@hourly"
   concurrency_policy = "Forbid"
   job_template {
     metadata {}
     spec {
       backoff_limit = 2
       template {
         metadata {}
         spec {
           container {
            name = "awscli"
            image = "amazon/aws-cli"
            command = [ "/bin/sh", "/script/script.sh" ]
            env {
              name = "HOSTED_ZONE_ID"
              value = local.externalname_zone_id
            }
            env {
              name = "AWS_DEFAULT_REGION"
              value = "eu-central-1"
            }
            env {
              name = "AWS_ACCESS_KEY_ID"
              value = local.access_key_id_dns
            }
            env {
              name = "AWS_SECRET_ACCESS_KEY"
              value = local.secret_access_key_dns
            }
            volume_mount {
              name = "script"
              mount_path = "/script"
            }
           }
           volume {
             name = "script"
             config_map {
               name = kubernetes_config_map.externalname.metadata.0.name
             }
           }
          }
        }
      }
    }
  }
}