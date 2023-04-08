variable "onepassword_connect_version" {
  type = string
}

variable onepassword_connect_host {
  type = string
}

variable onepassword_connect_credentials {
  type      = string
  sensitive = true
}
