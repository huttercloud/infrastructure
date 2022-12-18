variable "argo_cd_version" {
  type = string
}

variable argo_cd_host {
  type = string
}

variable argo_cd_server_admin_password {
  type = string
  sensitive = true
}

variable "argo_cd_auth0_issuer" {
  type = string
}

variable "argo_cd_auth0_client_id" {
  type = string
  sensitive = true
}

variable "argo_cd_auth0_client_secret" {
  type = string
  sensitive = true
}