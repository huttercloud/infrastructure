locals {
  # application versions
  external_dns_version           = "v0.13.5"
  external_secrets_version       = "0.10.2"
  argo_cd_version                = "7.5.0"

  # cert manager configuration
  cert_manager_email = "huttersebastian@gmail.com"

  # externalname (cname record in aws) configuration
  externalname_hostname = "infra.hutter.cloud"

  # external dns configuration
  txt_owner_id = "node-b-external-dns"

  # storage class configuration
  storage_class_name_data = "persistent"
  storage_class_path_data = "/data"

  # storage class for second disk
  storage_class_name_data_2 = "persistent-2"
  datastorage_class_path_data_2 = "/data2"

  # argo cd configuration
  argo_cd_host         = "argocd.hutter.cloud"
  argo_cd_auth0_issuer = "https://hutter-cloud.eu.auth0.com/"
}

