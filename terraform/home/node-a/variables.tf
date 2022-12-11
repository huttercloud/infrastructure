variable "external_dns_aws_access_key_id" {
    sensitive = true
    type = string
}

variable "external_dns_aws_secret_access_key" {
    sensitive = true
    type = string
}

variable "pi_hole_webpassword" {
    sensitive = true
    type = string
}

variable "oauth2_proxy_cookie_secret" {
    sensitive = true
    type = string
}

variable "wireguard_server_private_key" {
    sensitive = true
    type = string
}

variable "wireguard_client_sebastian_public_key" {
    sensitive = true
    type = string
}
