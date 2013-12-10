#!/bin/bash -ex

# Detect RVM
if (rvm >/dev/null 2>&1); then
    echo "Found RVM is installed! RVM is not supported by this installer. Remove it and rerun this script."
    exit 1
fi

# required to compile a gem native extension of CCNG
sudo apt-get -y install libmysqlclient-dev libpq-dev libsqlite3-dev

# Nise BOSH
if [ ! -d nise_bosh ]; then
    git clone https://github.com/nttlabs/nise_bosh.git
fi
(
    cd nise_bosh
    if [ "" != "$NISE_BOSH_REV" ]; then
        git checkout $NISE_BOSH_REV
    fi
    echo Use nise_bosh of revision: `git rev-list --max-count=1 HEAD` in $0
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
if ! (rbenv versions | grep -q 1.9.3-p448); then
    rbenv install 1.9.3-p448
fi
rbenv local 1.9.3-p448

# BOSH CLI and CF commands
gem install bundler cf --no-rdoc --no-ri
rbenv rehash

# cf-release
./local/clone_cf_release.sh

# Run
NISE_BOSH_REV=$NISE_BOSH_REV ./local/launch_nise_bosh.sh

# Postinstall
./local/postinstall.sh

set +x
NISE_IP_ADDRESS=${NISE_IP_ADDRESS:-`ip addr | grep 'inet .*global' | cut -f 6 -d ' ' | cut -f1 -d '/' | head -n 1`}
echo "Done!"
echo "RESTART your server!"
echo "CF target: 'cf target http://api.${NISE_DOMAIN:-${NISE_IP_ADDRESS}.xip.io}'"
echo "CF login : 'cf login --password ${NISE_PASSWORD:-c1oudc0w} admin'"
