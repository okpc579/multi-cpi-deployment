#!/bin/bash

bosh create-env openvpn.yml \
  --vars-store creds/vpn-deploy-az2.yml \
  --state openvpn-state-az2.json \
  -o operations/init-openstack.yml \
  -o operations/vpn-pushed-routes.yml \
  -o operations/vpn-ssh.yml \
  -o operations/vpn-server-ops.yml \
  -o operations/vpn-client-ops.yml \
  -v server_key_pair="$( bosh int creds/vpn-server-az2.yml --path /server_key_pair )" \
  -v client_key_pair="$( bosh int creds/vpn-server-az1.yml --path /client_key_pair )" \
  -l vars-az2.yml

