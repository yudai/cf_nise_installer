#!/bin/bash -ex

# gems
gem install cf --no-rdoc --no-ri
gem install admin-cf-plugin --no-rdoc --no-ri

# Disable nginx
# https://github.com/cloudfoundry/cf-release/pull/81
sudo sed  -i -e "s/check process nginx_ccng.*$//" /var/vcap/monit/job/0001_micro_ng.cloud_controller_ng.monitrc

# NFS for SDS
sudo apt-get install nfs-kernel-server
sudo sh -c "echo '/cfsnapshot     127.0.0.1(rw,sync,no_subtree_check)' >> /etc/exports"
sudo mkdir /cfsnapshot
sudo /etc/init.d/nfs-kernel-server restart
