#!/bin/bash -ex

# Git bootstrap
sudo apt-get update
sudo apt-get install -y git-core

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
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
    echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
fi
. ~/.bash_profile
if ! (rbenv versions | grep -q 1.9.3-p392); then
    rbenv install 1.9.3-p392
fi
rbenv local 1.9.3-p392

# BOSH CLI and CF commands
gem install bundler bosh_cli cf admin-cf-plugin --no-rdoc --no-ri
rbenv rehash

# cf-release
./scripts/clone_cf_release.sh

# Set current ip to nats server
export CURRENT_IP=`ip addr | grep 'inet .*global' | cut -f 6 -d ' ' | cut -f1 -d '/'` | head -n 1
sed -i "s/192.168.10.10/${CURRENT_IP}/g" manifests/micro.yml

# Run
(
    cd nise_bosh
    bundle install
    # Old spec format
    sudo env PATH=$PATH bundle exec ./bin/nise-bosh -y ../cf-release ../manifests/micro.yml micro
    # New spec format, keeping the  monit files installed in the previous run
    sudo env PATH=$PATH bundle exec ./bin/nise-bosh --keep-monit-files -y ../cf-release ../manifests/micro.yml micro_ng
)

# Postinstall
./scripts/postinstall.sh

# Startup
./scripts/start_processes.sh

# Tokens
./scripts/register_service_tokens.sh

set +x
echo "Done!"
echo "RESTART your server!"
