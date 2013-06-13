#!/bin/bash -ex

# Set current ip to nats server
NISE_IP_ADDRESS=${NISE_IP_ADDRESS:-`ip addr | grep 'inet .*global' | cut -f 6 -d ' ' | cut -f1 -d '/' | head -n 1`}
sed "s/192.168.10.10/${NISE_IP_ADDRESS}/g" manifests/micro.yml > manifests/deploy.yml

if [ "${NISE_DOMAIN}" != "" ]; then
    sed -i "s/${NISE_IP_ADDRESS}.xip.io/${NISE_DOMAIN}/g" manifests/deploy.yml
fi

(
    cd nise_bosh
    bundle install
    # Old spec format
    sudo env PATH=$PATH bundle exec ./bin/nise-bosh -y ../cf-release ../manifests/deploy.yml micro
    # New spec format, keeping the  monit files installed in the previous run
    sudo env PATH=$PATH bundle exec ./bin/nise-bosh --keep-monit-files -y ../cf-release ../manifests/deploy.yml micro_ng
)
