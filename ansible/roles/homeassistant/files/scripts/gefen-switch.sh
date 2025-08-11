#!/bin/bash
set -e

switch_alias = "$1"
switch_channel = "$2"

if [ -z "$switch_alias" ] || [ -z "$switch_channel" ]; then
  echo "Usage: $0 <switch_alias> <switch_channel>"
  exit 1
fi

# depending on the switch alias set the hostname
case "$switch_alias" in
  "oldschool")
    switch_host="hdmi-switch-oldschool.hutter.cloud"
    ;;
  "newschool")
    switch_host="hdmi-switch-newschool.hutter.cloud"
    ;;
  *)
    echo "Unknown switch alias: $switch_alias"
    exit 1
    ;;
esac

# send the command to the switch
echo -ne "R ${switch_channel}\r\n" | nc "${switch_host}" 23
