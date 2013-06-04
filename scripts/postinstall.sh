#!/bin/bash -ex

# gems
gem install cf admin-cf-plugin --no-rdoc --no-ri

# launch monit daemon
sudo /var/vcap/bosh/bin/monit
