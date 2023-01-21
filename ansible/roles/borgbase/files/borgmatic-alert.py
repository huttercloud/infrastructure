#!/usr/bin/env python3

import boto3
from botocore.config import Config
import click

@click.command()
@click.option('--aws-access-key-id', type=str, required=True)
@click.option('--aws-access-key-secret', type=str, required=True)
@click.option('--region', type=str, required=True)
@click.option('--sns-topic', type=str, required=True)
@click.option('--subject', type=str, required=True)
@click.option('--message', type=str, required=True)
def main(aws_access_key_id: str, aws_access_key_secret: str, region: str, sns_topic: str, subject: str, message: str):
  """
  publish message to sns topic in case of borgmatic error
  """

  sns = boto3.client('sns',
    aws_access_key_id=aws_access_key_id,
    aws_secret_access_key=aws_access_key_secret,
    config=Config(region_name=region),
  )

  sns.publish(
    TopicArn=sns_topic,
    Subject=subject,
    Message=message
  )


if __name__ == '__main__':
  main()
