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