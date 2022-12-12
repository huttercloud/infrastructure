variable "external_dns_aws_access_key_id" {
    sensitive = true
    type = string
}

variable "external_dns_aws_secret_access_key" {
    sensitive = true
    type = string
}

variable "oauth2_proxy_cookie_secret" {
    sensitive = true
    type = string
}