#!/bin/bash -ex

NISE_IP_ADDRESS=${NISE_IP_ADDRESS:-192.168.10.10}
VAGRANT_MEMORY=${VAGRANT_MEMORY:-4096}

NISE_IP_ADDRESS=${NISE_IP_ADDRESS} ./common/launch_nise_bosh.sh

BRIDGE_OPTION="--address=${NISE_IP_ADDRESS}"
if [ ${NISE_IP_ADDRESS} != "192.168.10.10" ]; then
    BRIDGE_OPTION="--bridge --address=${NISE_IP_ADDRESS}"
fi

if [ "" != "$NISE_BOSH_REV" ]; then
    if [ ! -d nise_bosh ]; then
        git clone https://github.com/nttlabs/nise_bosh.git
    fi
    (
        cd nise_bosh
        git checkout $NISE_BOSH_REV
        echo Use nise_bosh of revision: `git rev-list --max-count=1 HEAD` in $0
    )
    NISE_BOSH_PATH_OPTION="--nise ./nise_bosh"
fi

nise-bosh-vagrant ./cf-release --manifest ./manifests/deploy.yml --memory ${VAGRANT_MEMORY} --postinstall ./vagrant/postinstall.sh --install ${BRIDGE_OPTION} $NISE_BOSH_PATH_OPTION

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
