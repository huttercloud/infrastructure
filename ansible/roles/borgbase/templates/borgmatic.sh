#!/bin/bash

#
# wrapper script to use the correct borgmatic config file per job
#

{{ borgmatic_cli }} -c {{ borgmatic_config }} "${@}"