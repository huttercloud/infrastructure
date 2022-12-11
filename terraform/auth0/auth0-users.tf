# roles arent available in the free version
# resource "auth0_role" "usenet" {
#   name        = "Access to usenet services"
# }

locals {
  auth0_users = [
    {
        name = "Sebastian Hutter"
        email = "mail@sebastian-hutter.ch"
        password = var.user_password_sebastian
    },
    {
        name = "Christoph Rueger"
        email = "chrueeger@gmx.ch"
        password = var.user_password_christoph
    },
    {
        name = "Jacek Kikiewicz"
        email = "jacek@kikiewicz.com"
        password = var.user_password_jacek
    },
    {
        name = "Katharina Ebneter"
        email = "katha.ebneter@hotmail.com"
        password = var.user_password_katharina
    },
    {
        name = "Pascal Baettig"
        email = "pbaettig@gmail.com"
        password = var.user_password_pascal
    },
  ]
}

resource "auth0_user" "users" {
  for_each =  { for u in local.auth0_users: u.email => u}
  connection_name = "Username-Password-Authentication"
  name            = each.value.name
  email           = each.value.email
  email_verified  = true
  password        = each.value.password
}

