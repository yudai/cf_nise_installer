#!/bin/bash -ex

# gems
gem install cf admin-cf-plugin --no-rdoc --no-ri

# Disable nginx
# https://github.com/cloudfoundry/cf-release/pull/81
sudo sed  -i -e "s/check process nginx_ccng.*$//" /var/vcap/monit/job/0001_micro_ng.cloud_controller_ng.monitrc

# NFS for SDS
export_line='/cfsnapshot     127.0.0.1(rw,sync,no_subtree_check)'
sudo apt-get install nfs-kernel-server
if ! (grep -q "${export_line}" /etc/exports); then
    sudo sh -c "echo '${export_line}' >> /etc/exports"
fi
sudo mkdir -p /cfsnapshot
sudo /etc/init.d/nfs-kernel-server restart

# launch monit daemon
sudo /var/vcap/bosh/bin/monit
