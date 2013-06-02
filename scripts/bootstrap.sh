#!/bin/bash -ex

# sudo
sudo -v

INSTALLER_REPO=${INSTALLER_REPO:-https://raw.github.com/yudai/cf_nise_installer}
INSTALLER_BRANCH=${INSTALLER_BRANCH:-master}

installer_url=${INSTALLER_REPO}/${INSTALLER_BRANCH}
for file in local_install.sh clone_cf_release.sh postinstall.sh; do
    wget ${installer_url}/scripts/${file} -O ${file}
    chmod u+x ${file}
done

wget ${installer_url}/manifests/micro.yml -O micro.yml

./local_install.sh
