#!/bin/bash -ex

sudo /var/vcap/bosh/bin/monit
sleep 5

for process in \
    postgres \
    nats \
    cloud_controller_ng;
do
    sudo /var/vcap/bosh/bin/monit start $process
    sleep 30
done;

for process in \
    cloud_controller_jobs \
    nginx_ccng \
    gorouter \
    health_manager_next \
    uaa \
    uaa_cf-registrar \
    warden \
    dea_next \
    dir_server;
do
    sudo /var/vcap/bosh/bin/monit start $process
    sleep 5
done

echo "Waiting for all processes to start"
for ((i=0; i < 120; i++)); do
    if (sudo /var/vcap/bosh/bin/monit summary | tail -n +3 | grep -E "running$"); then
        break
    fi
    sleep 10
done
