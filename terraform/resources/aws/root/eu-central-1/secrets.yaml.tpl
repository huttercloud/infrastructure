secrets:
  oauth2proxy:
    cookiesecret: op://hutter.cloud/oauth2 proxy cookie secret/password
  pihole:
    webpassword: op://hutter.cloud/pi-hole admin/password
  synology:
    certificate:
      privatekey: op://Personal/id_rsa.synology-certificate/private_key_base64
  grafana:
    admin:
      password: op://hutter.cloud/grafana admin/password
    cloudmetrics:
      publisher: op://hutter.cloud/grafana cloud metricspublisher/password
  loki:
    gateway:
      credentials: op://hutter.cloud/loki gateway credentials/htpasswd
  calibre:
    opds:
      credentials: op://hutter.cloud/opds login calibre-web/htpasswd
  argocd:
    nodea:
      host: op://hutter.cloud/kubeconfig node-a/host
      token: op://hutter.cloud/kubeconfig node-a/token
      cert: op://hutter.cloud/kubeconfig node-a/cluster_ca_certificate
    nodeb:
      host: op://hutter.cloud/kubeconfig node-b/host
      token: op://hutter.cloud/kubeconfig node-b/token
      cert: op://hutter.cloud/kubeconfig node-b/cluster_ca_certificate
    github:
      deploykey: op://hutter.cloud/github.com applications deploy key for argocd/private_key_base64
  jenkins:
    secrets:
      alf: op://FFHS/Unity Personal License/base64_file
      deploymentkey: op://FFHS/Github Deployment Key for Unity Projects/private_key_base64
