#!/bin/bash -ex

sudo /var/vcap/bosh/bin/monit
sleep 5

for process in \
    nats_stream_forwarder \
    cloud_controller_jobs \
    nginx_ccng \
    gorouter \
    health_manager_next \
    uaa \
    uaa_cf-registrar \
    warden \
    dea_next \
    dir_server \
    cloud_controller_ng \
    nats;
do
    sudo /var/vcap/bosh/bin/monit stop $process
done

echo "Waiting for all processes but postgres to stop"
for ((i=0; i < 24; i++)); do
    if (sudo /var/vcap/bosh/bin/monit summary | tail -n +3 | grep -c -E -v "stop pending$" > /dev/null); then
        break
    fi
    sleep 5
done

if (sudo /var/vcap/bosh/bin/monit summary | tail -n +3 | grep -c -E "stop pending$" > /dev/null); then
  echo "Unable to stop processes"
else
  echo "Now stopping postgres..."
  sudo /var/vcap/bosh/bin/monit stop postgres
  for ((i=0; i < 12; i++)); do
    if (sudo /var/vcap/bosh/bin/monit summary | tail -n +3 | grep -c -E -v "stop pending$" > /dev/null); then
        break
    fi
    sleep 5
  done
  if (sudo /var/vcap/bosh/bin/monit summary | tail -n +3 | grep -c -E "stop pending$" > /dev/null); then
    echo "Unable to stop postgres processes"
  fi
fi