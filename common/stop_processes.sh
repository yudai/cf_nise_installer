#!/bin/bash -ex

sudo /var/vcap/bosh/bin/monit
sleep 5

for process in \
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
    COUNT=$(sudo /var/vcap/bosh/bin/monit summary | tail -n +3 | grep -c -E "stop pending$")
    if [ $COUNT == 0 ]; then
        break
    fi
    sleep 5
done

COUNT=$(sudo /var/vcap/bosh/bin/monit summary | tail -n +3 | grep -c -E "stop pending$")
if [ $COUNT != 0 ]; then
  echo "Unable to stop processes"
else 
  echo "Now stopping postgres..."
  sudo /var/vcap/bosh/bin/monit stop postgres
  for ((i=0; i < 12; i++)); do
    COUNT=$(sudo /var/vcap/bosh/bin/monit summary | tail -n +3 | grep -c -E "stop pending$")
    if [ $COUNT == 0 ]; then
        break
    fi
    sleep 5
  done
  if [ $COUNT != 0 ]; then
    echo "Unable to stop postgres processes"
  fi
fi
