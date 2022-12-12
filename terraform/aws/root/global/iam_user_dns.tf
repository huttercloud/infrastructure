#
# create iam user to manage dns entries in hutter.cloud
# zone
#

resource "aws_iam_user" "dns" {
  name = "hutter_cloud_dns"
}

resource "aws_iam_access_key" "dns" {
  user = aws_iam_user.dns.name
}

resource "aws_iam_user_policy_attachment" "dns" {
    user = aws_iam_user.dns.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonRoute53FullAccess"
}

output "user_dns_access_key_id" {
  value = aws_iam_access_key.dns.id
}

output "user_dns_secret_access_key" {
  value = aws_iam_access_key.dns.secret
  sensitive = true
}