#
# create iam user allowing accessing secrets
# stored in parameter store (for external-secrets)
#

resource "aws_iam_user" "secrets_manager" {
  name = "hutter_cloud_secrets_manager"
}

resource "aws_iam_access_key" "secrets_manager" {
  user = aws_iam_user.secrets_manager.name
}

resource "aws_iam_user_policy_attachment" "secrets_manager" {
  user       = aws_iam_user.secrets_manager.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

output "user_secrets_manager_access_key_id" {
  value = aws_iam_access_key.secrets_manager.id
}

output "user_secrets_manager_secret_access_key" {
  value     = aws_iam_access_key.secrets_manager.secret
  sensitive = true
}
