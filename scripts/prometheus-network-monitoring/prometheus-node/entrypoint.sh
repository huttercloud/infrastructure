#!/bin/bash

/usr/local/bin/mikrotik-exporter -address $MIKROTIK_ADDRESS -device router -user $MIKROTIK_USER -password $MIKROTIK_PASSWORD
