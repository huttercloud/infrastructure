

# github machine user ssh key
resource "aws_secretsmanager_secret" "hutter_cloud_service_jenkins_secret_github_machine_user_ssh_key" {
  name  = "github-machine-user-ssh-key"
  tags = {
    "jenkins:credentials:type" = "sshUserPrivateKey"
    "jenkins:credentials:username" = "git"
  }
}

resource "aws_secretsmanager_secret_version" "hutter_cloud_service_jenkins_secret_github_machine_user_ssh_key" {
  secret_id     = aws_secretsmanager_secret.hutter_cloud_service_jenkins_secret_github_machine_user_ssh_key.id
  secret_string = base64decode(local.secrets.jenkins.secrets.github.key)
}

# github machine user pat
resource "aws_secretsmanager_secret" "hutter_cloud_service_jenkins_secret_github_machine_user_pat" {
  name  = "github-machine-user-pat"
  tags = {
    "jenkins:credentials:type" = "usernamePassword"
    "jenkins:credentials:username" = local.secrets.jenkins.secrets.github.pat.username
  }
}

resource "aws_secretsmanager_secret_version" "hutter_cloud_service_jenkins_secret_github_machine_user_pat" {
  secret_id     = aws_secretsmanager_secret.hutter_cloud_service_jenkins_secret_github_machine_user_pat.id
  secret_string = local.secrets.jenkins.secrets.github.pat.token
}

# github machine user pat for webhook registration
resource "aws_secretsmanager_secret" "hutter_cloud_service_jenkins_secret_github_machine_user_webhook_pat" {
  name  = "github-machine-user-webhook-pat"
  tags = {
    "jenkins:credentials:type" = "string"
  }
}

resource "aws_secretsmanager_secret_version" "hutter_cloud_service_jenkins_secret_github_machine_user_webhook_pat" {
  secret_id     = aws_secretsmanager_secret.hutter_cloud_service_jenkins_secret_github_machine_user_webhook_pat.id
  secret_string = local.secrets.jenkins.secrets.github.webhook
}


# aws secretsmanager access key and secret
resource "aws_secretsmanager_secret" "hutter_cloud_service_jenkins_secret_secrets_manager" {
  name  = "aws-secretsmanager"
  tags = {
    "jenkins:credentials:type" = "usernamePassword"
    "jenkins:credentials:username" = data.terraform_remote_state.aws-root-global.outputs.user_secrets_manager_access_key_id
  }
}
resource "aws_secretsmanager_secret_version" "hutter_cloud_service_jenkins_secret_secrets_manager" {
  secret_id     = aws_secretsmanager_secret.hutter_cloud_service_jenkins_secret_secrets_manager.id
  secret_string = data.terraform_remote_state.aws-root-global.outputs.user_secrets_manager_secret_access_key
}

#
# ssh key for access of node-a, b, c and plex
#

resource "aws_secretsmanager_secret" "hutter_cloud_service_jenkins_secret_infrastructure_ssh_key_jenkinsci" {
  name  = "jenkinsci-ssh-key"
  tags = {
    "jenkins:credentials:type" = "sshUserPrivateKey"
    "jenkins:credentials:username" = "jenkinsci"
  }
}

resource "aws_secretsmanager_secret_version" "hutter_cloud_service_jenkins_secret_infrastructure_ssh_key_jenkinsci" {
  secret_id     = aws_secretsmanager_secret.hutter_cloud_service_jenkins_secret_infrastructure_ssh_key_jenkinsci.id
  secret_string = base64decode(local.secrets.jenkins.secrets.infrastructure.key)
}

#
# 1password token for 1password connect access
#

resource "aws_secretsmanager_secret" "hutter_cloud_service_jenkins_secret_1password_connect_token" {
  name  = "jenkinsci-1password-connect-token"
  tags = {
    "jenkins:credentials:type" = "string"
  }
}

resource "aws_secretsmanager_secret_version" "hutter_cloud_service_jenkins_secret_1password_connect_token" {
  secret_id     = aws_secretsmanager_secret.hutter_cloud_service_jenkins_secret_1password_connect_token.id
  secret_string = local.secrets.jenkins.secrets.onepassword.token
}

#
# 1password token for 1password connect access
#

resource "aws_secretsmanager_secret" "hutter_cloud_service_jenkins_secret_terraform_cloud_token" {
  name  = "jenkinsci-terraform-cloud-token"
  tags = {
    "jenkins:credentials:type" = "string"
  }
}

resource "aws_secretsmanager_secret_version" "hutter_cloud_service_jenkins_secret_terraform_cloud_token" {
  secret_id     = aws_secretsmanager_secret.hutter_cloud_service_jenkins_secret_terraform_cloud_token.id
  secret_string = local.secrets.jenkins.secrets.terraform.token
}

