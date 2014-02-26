#!/bin/bash -ex

# Detect RVM
if (rvm >/dev/null 2>&1); then
    echo "Found RVM is installed! RVM is not supported by this installer. Remove it and rerun this script."
    exit 1
fi

sudo apt-get update

./scripts/install_ruby.sh
source ~/.profile

./scripts/clone_nise_bosh.sh
./scripts/clone_cf_release.sh

./scripts/install_environemnt.sh
./scripts/install_cf_release.sh

set +x
echo "Done!"
echo "You can launch Cloud Foundry with './scripts/start.sh'"
echo "Restart your server before starting processes if you are using Ubuntu 10.04"
