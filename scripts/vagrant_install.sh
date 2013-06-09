#!/bin/bash -ex

# Check Git
if ! (which git); then
    echo "Git command not found"
    exit 1
fi

# Check Ruby
if ! (which ruby > /dev/null && ruby --version | grep "1.9.3p392" -q); then
    echo "Ruby 1.9.3p392 not found"
    exit 1
fi

# Gems
gem install bundler bosh_cli cf admin-cf-plugin --no-rdoc --no-ri

# cf-release
./scripts/clone_cf_release.sh

# Install
./scripts/launch_vagrant.sh

# Startup
(
    cd cf-release
    vagrant ssh -c "`cat ../scripts/start_processes.sh`"
)

# Tokens
./scripts/register_service_tokens.sh

set +x
echo "Done!"
echo "Your devbox is working now:"
echo "CF target: 'cf target api.${BRIDGE_IP_ADDRESS:=192.168.10.10}.xip.io'"
echo "CF login: 'cf login --password micr0@micr0 micro@vcap.me'"
