#!/bin/bash -ex

# NFS for SDS
export_line='/cfsnapshot     127.0.0.1(rw,sync,no_subtree_check)'
sudo apt-get install nfs-kernel-server
if ! (grep -q "${export_line}" /etc/exports); then
    sudo sh -c "echo '${export_line}' >> /etc/exports"
fi
sudo mkdir -p /cfsnapshot
sudo /etc/init.d/nfs-kernel-server restart

# remove unnecessary restriction
sudo sed -i "s/bind-address            = 127.0.0.1//g" /var/vcap/jobs/mysql_node_ng/config/my.cnf
sudo sed -i "s/bind-address            = 127.0.0.1//g" /var/vcap/jobs/mysql_node_ng/config/my55.cnf
sudo sed -i "s/listen_addresses = '127.0.0.1'/listen_addresses = '*'/g" /var/vcap/jobs/postgresql_node_ng/config/postgresql.conf
sudo sed -i "s/listen_addresses = '127.0.0.1'/listen_addresses = '*'/g" /var/vcap/jobs/postgresql_node_ng/config/postgresql91.conf
sudo sed -i "s/listen_addresses = '127.0.0.1'/listen_addresses = '*'/g" /var/vcap/jobs/postgresql_node_ng/config/postgresql92.conf
