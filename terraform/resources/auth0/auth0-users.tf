# roles arent available in the free version
# resource "auth0_role" "usenet" {
#   name        = "Access to usenet services"
# }

locals {
  auth0_users = yamldecode(file("${path.module}/accounts.yaml")).accounts
}


resource "auth0_user" "users" {
  for_each        = { for u in local.auth0_users : u.email => u }
  connection_name = "Username-Password-Authentication"
  name            = each.value.name
  email           = each.value.email
  email_verified  = true
  password        = each.value.password

  lifecycle {
    ignore_changes = [
      password,
    ]
  }
}

