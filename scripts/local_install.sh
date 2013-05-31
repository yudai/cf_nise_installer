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
gem install bundler --no-rdoc --no-ri
gem install bosh_cli --no-rdoc --no-ri
rbenv rehash

# cf-release
./clone_cf_release.sh

# Set current ip to nats server
current_ip=`ip addr | grep 'inet .*global' | cut -f 6 -d ' ' | cut -f1 -d '/'`
sed -i "s/192.168.10.10/${current_ip}/g" micro.yml

# Run
(
    cd nise_bosh
    bundle install
    # Old spec format
    sudo env PATH=$PATH bundle exec ./bin/nise-bosh -y ../cf-release ../micro.yml micro
    # New spec format, keeping the  monit files installed in the previous run
    sudo env PATH=$PATH bundle exec ./bin/nise-bosh --keep-monit-files -y ../cf-release ../micro.yml micro_ng
)

# Postinstall
./postinstall.sh

set +x
echo "Done!"
echo "Start CF processes: 'sudo /var/vcap/bosh/bin/monit start all'"
echo "Check the status of CF processes: 'sudo /var/vcap/bosh/bin/monit status'"
echo "Simpler status summary: 'sudo /var/vcap/bosh/bin/monit summary'"
echo "CF target: 'cf target api.vcap.me'"
echo "CF login: 'cf login --password micr0@micr0 micro@vcap.me'"
echo "Register service tokens: 'cf create-service-auth-token --provider core --token token --label postgresql'"
echo "                         'cf create-service-auth-token --provider core --token token --label mysql'"
