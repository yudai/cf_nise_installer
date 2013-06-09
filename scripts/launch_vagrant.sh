#!/bin/bash -ex

BRIDGE_IP_ADDRESS=${BRIDGE_IP_ADDRESS:-}
VAGRANT_MEMORY=${VAGRANT_MEMORY:-4096}
nise-bosh-vagrant ./cf-release --manifest ./manifests/micro.yml --memory ${VAGRANT_MEMORY} --postinstall ./scripts/postinstall.sh --install ${BRIDGE_IP_ADDRESS:+ --bridge --address=${BRIDGE_IP_ADDRESS}}

# Reboot VM once to reload kernel
(
    cd cf-release
    vagrant ssh -c "sudo reboot" | true
    sleep 10
    vagrant ssh -c "sudo /etc/init.d/vboxadd setup"
    vagrant halt
    sleep 10
    vagrant up
)
