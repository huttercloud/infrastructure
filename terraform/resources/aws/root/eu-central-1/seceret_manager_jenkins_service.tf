

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
