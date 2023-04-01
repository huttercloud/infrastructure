

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

# unity personal license
resource "aws_secretsmanager_secret" "hutter_cloud_service_jenkins_secret_unity_personal_license" {
  name  = "unity-personal-license"
  tags = {
    "jenkins:credentials:type" = "file"
  }
}
resource "aws_secretsmanager_secret_version" "hutter_cloud_service_jenkins_secret_unity_personal_license" {
  secret_id     = aws_secretsmanager_secret.hutter_cloud_service_jenkins_secret_unity_personal_license.id
  secret_binary = local.secrets.jenkins.secrets.unity.alf

  lifecycle {
    ignore_changes = [
      secret_binary
    ]
  }
}

# unity id
resource "aws_secretsmanager_secret" "hutter_cloud_service_jenkins_secret_unity_id" {
  name  = "unity-id"
  tags = {
    "jenkins:credentials:type" = "usernamePassword"
    "jenkins:credentials:username" = local.secrets.jenkins.secrets.unity.username
  }
}
resource "aws_secretsmanager_secret_version" "hutter_cloud_service_jenkins_secret_unity_id" {
  secret_id     = aws_secretsmanager_secret.hutter_cloud_service_jenkins_secret_unity_id.id
  secret_string = local.secrets.jenkins.secrets.unity.password
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
# same ssh key but different usernames!
#

# node-a
resource "aws_secretsmanager_secret" "hutter_cloud_service_jenkins_secret_infrastructure_ssh_key_node_a" {
  name  = "node-a-ssh-key"
  tags = {
    "jenkins:credentials:type" = "sshUserPrivateKey"
    "jenkins:credentials:username" = "node"
  }
}

resource "aws_secretsmanager_secret_version" "hutter_cloud_service_jenkins_secret_infrastructure_ssh_key_node_a" {
  secret_id     = aws_secretsmanager_secret.hutter_cloud_service_jenkins_secret_infrastructure_ssh_key_node_a.id
  secret_string = base64decode(local.secrets.jenkins.secrets.infrastructure.key)
}

# node-b
resource "aws_secretsmanager_secret" "hutter_cloud_service_jenkins_secret_infrastructure_ssh_key_node_b" {
  name  = "node-b-ssh-key"
  tags = {
    "jenkins:credentials:type" = "sshUserPrivateKey"
    "jenkins:credentials:username" = "node"
  }
}

resource "aws_secretsmanager_secret_version" "hutter_cloud_service_jenkins_secret_infrastructure_ssh_key_node_b" {
  secret_id     = aws_secretsmanager_secret.hutter_cloud_service_jenkins_secret_infrastructure_ssh_key_node_b.id
  secret_string = base64decode(local.secrets.jenkins.secrets.infrastructure.key)
}

# node-c
resource "aws_secretsmanager_secret" "hutter_cloud_service_jenkins_secret_infrastructure_ssh_key_node_c" {
  name  = "node-c-ssh-key"
  tags = {
    "jenkins:credentials:type" = "sshUserPrivateKey"
    "jenkins:credentials:username" = "sebastianhutter"
  }
}

resource "aws_secretsmanager_secret_version" "hutter_cloud_service_jenkins_secret_infrastructure_ssh_key_node_c" {
  secret_id     = aws_secretsmanager_secret.hutter_cloud_service_jenkins_secret_infrastructure_ssh_key_node_c.id
  secret_string = base64decode(local.secrets.jenkins.secrets.infrastructure.key)
}


# plex
resource "aws_secretsmanager_secret" "hutter_cloud_service_jenkins_secret_infrastructure_ssh_key_plex" {
  name  = "plex-ssh-key"
  tags = {
    "jenkins:credentials:type" = "sshUserPrivateKey"
    "jenkins:credentials:username" = "plex"
  }
}

resource "aws_secretsmanager_secret_version" "hutter_cloud_service_jenkins_secret_infrastructure_ssh_key_plex" {
  secret_id     = aws_secretsmanager_secret.hutter_cloud_service_jenkins_secret_infrastructure_ssh_key_plex.id
  secret_string = base64decode(local.secrets.jenkins.secrets.infrastructure.key)
}
