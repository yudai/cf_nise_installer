#!/bin/bash -ex

# Detect RVM
if (rvm >/dev/null 2>&1); then
    echo "Found RVM is installed! RVM is not supported by this installer. Remove it and rerun this script."
    exit 1
fi

# required to compile a gem native extension of CCNG
sudo apt-get update
sudo apt-get -y install git-core libmysqlclient-dev libpq-dev libsqlite3-dev

# Nise BOSH
./scripts/clone_nise_bosh.sh
(
    cd nise_bosh
    sudo ./bin/init
)

# Ruby
if [ ! -d ~/.rbenv ]; then
    git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
    git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.profile
    echo 'eval "$(rbenv init -)"' >> ~/.profile
fi
. ~/.profile
if ! (rbenv versions | grep -q 1.9.3-p484); then
    rbenv install 1.9.3-p484
fi
rbenv local 1.9.3-p484

# BOSH CLI and CF commands
gem install bundler cf --no-rdoc --no-ri
gem install rake -v 0.9.2.2 # hack for collector
rbenv rehash

# cf-release
./scripts/clone_cf_release.sh

# Run
NISE_BOSH_REV=$NISE_BOSH_REV ./scripts/launch_nise_bosh.sh

set +x
NISE_IP_ADDRESS=${NISE_IP_ADDRESS:-`ip addr | grep 'inet .*global' | cut -f 6 -d ' ' | cut -f1 -d '/' | head -n 1`}
echo "Done!"
echo "RESTART your server!"
echo "CF target: 'cf target http://api.${NISE_DOMAIN:-${NISE_IP_ADDRESS}.xip.io}'"
echo "CF login : 'cf login --password ${NISE_PASSWORD:-c1oudc0w} admin'"
