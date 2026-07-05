#
# dedicated IAM user for maintainerr to send notification mails through SES.
# the generated access key doubles as SES SMTP credentials (username =
# access key id, password = ses_smtp_password_v4).
#

resource "aws_iam_user" "maintainerr_ses" {
  name = "maintainerr-ses"
}

resource "aws_iam_access_key" "maintainerr_ses" {
  user = aws_iam_user.maintainerr_ses.name
}

# only allow sending mail from our verified hutter.cloud identity
data "aws_iam_policy_document" "maintainerr_ses" {
  statement {
    actions = [
      "ses:SendEmail",
      "ses:SendRawEmail",
    ]

    resources = [
      "*"
    ]
  }
}

resource "aws_iam_user_policy" "maintainerr_ses" {
  name   = "maintainerr-ses-send"
  user   = aws_iam_user.maintainerr_ses.name
  policy = data.aws_iam_policy_document.maintainerr_ses.json
}

output "maintainerr_smtp_host" {
  value = "email-smtp.${data.aws_region.current.name}.amazonaws.com"
}

output "maintainerr_smtp_port" {
  value = 587
}

output "maintainerr_smtp_username" {
  value = aws_iam_access_key.maintainerr_ses.id
}

output "maintainerr_smtp_password" {
  value     = aws_iam_access_key.maintainerr_ses.ses_smtp_password_v4
  sensitive = true
}
