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
    nats_stream_forwarder \
    cloud_controller_jobs \
    nginx_ccng \
    gorouter \
    etcd \
    hm9000_listener \
    hm9000_fetcher \
    hm9000_analyzer \
    hm9000_sender \
    hm9000_metrics_server \
    hm9000_api_server \
    hm9000_evacuator \
    hm9000_shredder \
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
