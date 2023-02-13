#
# parse the yaml file containing the secre
#

locals {
  secrets = yamldecode(file("${path.module}/secrets.yaml")).secrets
}





