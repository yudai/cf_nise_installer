#!/bin/bash -ex

# Check Git
if ! (which git > /dev/null); then
    echo "Git command not found"
    exit 1
fi

# Check Ruby
if ! (which ruby > /dev/null && ruby --version | grep "1.9.3p448" -q); then
    echo "Ruby 1.9.3p448 not found"
    exit 1
fi

# Gems
gem install bundler cf nise-bosh-vagrant --no-rdoc --no-ri

# cf-release
./vagrant/clone_cf_release.sh

# Install and start
./vagrant/launch_nise_bosh.sh

# Startup
./vagrant/start_processes.sh

set +x
echo "Done!"
echo "Your devbox is already working:"
echo "CF target: 'cf target http://api.${NISE_DOMAIN:-${NISE_IP_ADDRESS:-192.168.10.10}.xip.io}'"
echo "CF login : 'cf login --password ${NISE_PASSWORD:-c1oudc0w} admin'"
