#!/bin/bash -ex

INSTALLER_REPO=${INSTALLER_REPO:-https://raw.github.com/yudai/cf_nise_installer}

for file in local_install.sh clone_cf_release.sh postinstall.sh; do
    wget ${INSTALLER_REPO}/master/scripts/${file} -O ${file}
    chmod u+x ${file}
done

wget ${INSTALLER_REPO}/master/manifests/micro.yml -O micro.yml

./local_install.sh
