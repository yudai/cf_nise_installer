#!/bin/bash -ex

NISE_IP_ADDRESS=${NISE_IP_ADDRESS:-192.168.10.10}
VAGRANT_MEMORY=${VAGRANT_MEMORY:-4096}

cp manifests/micro.yml manifests/deploy.yml


if [ "${NISE_DOMAIN}" != "" ]; then
    if (! sed --version 1>/dev/null 2>&1); then
        # not a GNU sed
        sed -i '' "s/${NISE_IP_ADDRESS}.xip.io/${NISE_DOMAIN}/g" manifests/deploy.yml
    else
        sed -i "s/${NISE_IP_ADDRESS}.xip.io/${NISE_DOMAIN}/g" manifests/deploy.yml
    fi
fi

BRIDGE_OPTION=
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
