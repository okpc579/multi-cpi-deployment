echo "create vpn-server-az1....."
bosh int operations/vpn-ca-server.yml \
  -l vars-az1.yml \
  --vars-store=creds/vpn-server-az1.yml

echo "create vpn-server-az2....."
bosh int operations/vpn-ca-server.yml \
  -l vars-az2.yml \
  --vars-store=creds/vpn-server-az2.yml

