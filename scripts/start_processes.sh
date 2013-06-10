#/bin/bosh -ex

sudo /var/vcap/bosh/bin/monit

sudo /var/vcap/bosh/bin/monit start all

echo "Waiting for all processes to start"
for ((i=0; i < 120; i++)); do
    if (sudo /var/vcap/bosh/bin/monit summary | tail -n +3 | grep -E "running$"); then
        break
    fi
    sleep 10
done
