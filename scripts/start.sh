#!/bin/bash -ex

path=`dirname $0`
cd "$path"/../

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
    if ! (sudo /var/vcap/bosh/bin/monit summary | tail -n +3 | grep -v -E "(running|accessible)$"); then
        break
    fi
    sleep 10
done

if (sudo /var/vcap/bosh/bin/monit summary | tail -n +3 | grep -v -E "(running|accessible)$"); then
    echo "Found process failed to start"
    exit 1
fi

set +x
echo "All processes have been started!"
api_url=`grep srv_api_uri: ./manifests/deploy.yml | awk '{ print $2 }'`
password=`grep ' - admin' ./manifests/deploy.yml | cut -f 2 -d '|'  `
echo "Login : 'cf login -a ${api_url} -u admin -p ${password} --skip-ssl-validation'"
echo "Download CF CLI from https://github.com/cloudfoundry/cli"
