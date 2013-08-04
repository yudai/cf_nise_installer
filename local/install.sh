#!/bin/bash -ex

# Git bootstrap
if ! (which git); then
    sudo apt-get update
    sudo apt-get install -y git-core
fi

# Nise BOSH
if [ ! -d nise_bosh ]; then
    git clone https://github.com/nttlabs/nise_bosh.git
fi
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
if ! (rbenv versions | grep -q 1.9.3-p448); then
    rbenv install 1.9.3-p448
fi
rbenv local 1.9.3-p448

# BOSH CLI and CF commands
gem install bundler cf admin-cf-plugin --no-rdoc --no-ri
rbenv rehash

# cf-release
./local/clone_cf_release.sh

# Run
./local/launch_nise_bosh.sh

# Postinstall
./local/postinstall.sh

set +x
NISE_IP_ADDRESS=${NISE_IP_ADDRESS:-`ip addr | grep 'inet .*global' | cut -f 6 -d ' ' | cut -f1 -d '/' | head -n 1`}
echo "Done!"
echo "RESTART your server!"
echo "CF target: 'cf target api.${NISE_IP_ADDRESS}.xip.io'"
echo "CF login : 'cf login --password micr0@micr0 micro@vcap.me'"
