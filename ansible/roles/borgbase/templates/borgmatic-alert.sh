#!/bin/bash

#
# wrapper script to send alerts to sns topic via the python script
#

{{ borgmatic_venv_python }} {{ borgmatic_alert_script }} \
  --aws-access-key-id {{ aws_access_key_id }} \
  --aws-access-key-secret {{ aws_access_key_secret }} \
  --region {{ region }} \
  --sns-topic {{ sns_topic }} \
  --subject "${1}" \
  --message "${2}"
