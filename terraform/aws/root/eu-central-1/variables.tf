variable "pi_hole_webpassword" {
    sensitive = true
    type = string
}

variable "oauth2_proxy_cookie_secret" {
    sensitive = true
    type = string
}
