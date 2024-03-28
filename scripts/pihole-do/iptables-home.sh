#!/bin/bash

iptables -N homeDNS 2>/dev/null || true
iptables -I INPUT -j homeDNS
iptables -F homeDNS
iptables -I homeDNS -p udp --dport 53 -j DROP
iptables -I homeDNS -p tcp --dport 80 -j DROP
iptables -I homeDNS -p udp -s $(dig +short home.hutter.cloud) --dport 53 -j ACCEPT
iptables -I homeDNS -p tcp -s $(dig +short home.hutter.cloud) --dport 80 -j ACCEPT
iptables -I homeDNS -p udp -s 10.255.255.0/24 --dport 53 -j ACCEPT
iptables -I homeDNS -p udp -s 192.168.30.0/24 --dport 53 -j ACCEPT
iptables -I homeDNS -p tcp -s 10.255.255.0/24 --dport 80 -j ACCEPT
iptables -I homeDNS -p tcp -s 192.168.30.0/24 --dport 80 -j ACCEPT
