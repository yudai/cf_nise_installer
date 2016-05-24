#!/bin/bash -ex

if [ ! -f /etc/lsb-release ] || \
   [ `uname -m` != "x86_64" ]; then
    echo "This installer supports only Ubuntu 10.04, 12.04 and 14.04 64bit server."
    exit 1;
fi

# Git bootstrap
if ! (which git); then
    sudo apt-get update
    sudo apt-get install -y git-core
fi

INSTALLER_URL=${INSTALLER_URL:-https://github.com/yudai/cf_nise_installer.git}
INSTALLER_BRANCH=${INSTALLER_BRANCH:-master}

if [ ! -d cf_nise_installer ]; then
    git clone ${INSTALLER_URL} cf_nise_installer
fi

(
    cd cf_nise_installer
    git checkout ${INSTALLER_BRANCH}
    ./scripts/install.sh
)
