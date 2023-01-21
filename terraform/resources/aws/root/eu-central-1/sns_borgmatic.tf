#
# setup sns topic and subscription for borgmatic backup alerts
#

resource "aws_sns_topic" "borgmatic" {
  name = "borgmatic"
}

resource "aws_sns_topic_subscription" "borgmatic" {
  topic_arn = aws_sns_topic.borgmatic.arn
  protocol = "email"
  endpoint = "huttersebastian+borgmatic-alert@gmail.com"
}

resource "aws_iam_user" "borgmatic" {
    name = "borgmatic-alert"
}

resource "aws_iam_access_key" "borgmatic" {
  user = aws_iam_user.borgmatic.name
}

data "aws_iam_policy_document" "borgmatic" {
  statement {

    actions = [
      "sns:Publish"
    ]

    resources = [
      aws_sns_topic.borgmatic.arn
    ]
  }
}

resource "aws_iam_user_policy" "borgmatic" {
  name = "borgmatic-alert"
  user = aws_iam_user.borgmatic.name
  policy = data.aws_iam_policy_document.borgmatic.json
}

output "borgmatic_sns_topic" {
    value = aws_sns_topic.borgmatic.arn
}

output "borgmatic_access_key" {
    value = aws_iam_access_key.borgmatic.id
}

output "borgmatic_access_key_secret" {
    value = aws_iam_access_key.borgmatic.secret
    sensitive = true
}
