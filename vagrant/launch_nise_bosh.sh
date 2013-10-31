#!/bin/bash -ex

NISE_IP_ADDRESS=${NISE_IP_ADDRESS:-192.168.10.10}
VAGRANT_MEMORY=${VAGRANT_MEMORY:-4096}

NISE_IP_ADDRESS=${NISE_IP_ADDRESS} ./common/launch_nise_bosh.sh

BRIDGE_OPTION="--address=${NISE_IP_ADDRESS}"
if [ ${NISE_IP_ADDRESS} != "192.168.10.10" ]; then
    BRIDGE_OPTION="--bridge --address=${NISE_IP_ADDRESS}"
fi

nise-bosh-vagrant ./cf-release --manifest ./manifests/deploy.yml --memory ${VAGRANT_MEMORY} --postinstall ./vagrant/postinstall.sh --install ${BRIDGE_OPTION}

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
