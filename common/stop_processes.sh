#!/bin/bash -ex

sudo /var/vcap/bosh/bin/monit
sleep 5

for process in \
    postgres \
    nats \
    cloud_controller_ng;
do
    sudo /var/vcap/bosh/bin/monit stop $process
done;

for process in \
    nginx_ccng \
    gorouter \
    health_manager_next \
    uaa \
    uaa_cf-registrar \
    warden \
    dea_next \
    dir_server;
do
    sudo /var/vcap/bosh/bin/monit stop $process
done
