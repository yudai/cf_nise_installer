#!/bin/bash -ex

sudo /var/vcap/bosh/bin/monit
sleep 5

for process in \
    postgres \
    nats
do
    sudo /var/vcap/bosh/bin/monit start $process
    sleep 30
done;

sudo /var/vcap/bosh/bin/monit start all


echo "Waiting for all processes to start"
for ((i=0; i < 120; i++)); do
    if ! (sudo /var/vcap/bosh/bin/monit summary | tail -n +3 | grep -v -E "running$"); then
        break
    fi
    sleep 10
done

if (sudo /var/vcap/bosh/bin/monit summary | tail -n +3 | grep -v -E "running$"); then
    echo "Found process failed to start"
    exit 1
fi

echo "All processes have been started!"
