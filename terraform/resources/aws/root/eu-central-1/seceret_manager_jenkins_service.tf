

# password for pihole web interface
resource "aws_secretsmanager_secret" "hutter_cloud_service_jenkins_secret_unity_deployment_key" {
  name  = "github-unity-deployment-key"
  tags = {
    "jenkins:credentials:type" = "sshUserPrivateKey"
    "jenkins:credentials:username" = "git"
  }
}

resource "aws_secretsmanager_secret_version" "hutter_cloud_service_jenkins_secret_unity_deployment_key" {
  secret_id     = aws_secretsmanager_secret.hutter_cloud_service_jenkins_secret_unity_deployment_key.id
  secret_string = base64decode(local.secrets.jenkins.secrets.deploymentkey)
}

resource "aws_secretsmanager_secret" "hutter_cloud_service_jenkins_secret_unity_personal_license" {
  name  = "unity-personal-license"
  tags = {
    "jenkins:credentials:type" = "file"
  }
}

resource "aws_secretsmanager_secret_version" "hutter_cloud_service_jenkins_secret_unity_personal_license" {
  secret_id     = aws_secretsmanager_secret.hutter_cloud_service_jenkins_secret_unity_personal_license.id
  secret_binary = local.secrets.jenkins.secrets.alf
}
