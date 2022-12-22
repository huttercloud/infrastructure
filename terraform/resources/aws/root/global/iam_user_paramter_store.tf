#
# create iam user allowing accessing secrets
# stored in parameter store (for external-secrets)
#

resource "aws_iam_user" "parameter_store" {
  name = "hutter_cloud_parameter_store"
}

resource "aws_iam_access_key" "parameter_store" {
  user = aws_iam_user.parameter_store.name
}

resource "aws_iam_user_policy_attachment" "parameter_store" {
  user       = aws_iam_user.parameter_store.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

output "user_parameter_store_access_key_id" {
  value = aws_iam_access_key.parameter_store.id
}

output "user_parameter_store_secret_access_key" {
  value     = aws_iam_access_key.parameter_store.secret
  sensitive = true
}