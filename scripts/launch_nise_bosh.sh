#!/bin/bash -ex

# Set current ip to nats server
NISE_IP_ADDRESS=${NISE_IP_ADDRESS:-`ip addr | grep 'inet .*global' | cut -f 6 -d ' ' | cut -f1 -d '/' | head -n 1`}
CF_RELEASE_USE_HEAD=${CF_RELEASE_USE_HEAD:-no}

pushd nise_bosh
bundle install
release_version=`bundle exec ./bin/nise-bosh -w -m ../cf-release`
base_release_version=`echo $release_version | cut -f 1 -d '-' | cut -f 1 -d '.'`
popd

pushd manifests
for version in `ls * | cut -f 1 -d '.' | sort -n -r`; do
    if [ $version -le $base_release_version ]; then
        selected_manifest=$version
        break
    fi
done
popd

if [ $CF_RELEASE_USE_HEAD != "no" ]; then
    manifest_for_next_version=`expr $base_release_version + 1`
    if [ -f "manifests/${manifest_for_next_version}.yml" ]; then
        selected_manifest=$manifest_for_next_version
    fi
fi

sed "s/192.168.10.10/${NISE_IP_ADDRESS}/g" manifests/${selected_manifest}.yml > .deploy.yml

if [ "${NISE_DOMAIN}" != "" ]; then
    if (! sed --version 1>/dev/null 2>&1); then
        # not a GNU sed
        sed -i '' "s/${NISE_IP_ADDRESS}.xip.io/${NISE_DOMAIN}/g" .deploy.yml
    else
        sed -i "s/${NISE_IP_ADDRESS}.xip.io/${NISE_DOMAIN}/g" .deploy.yml
    fi
fi

if [ "${NISE_PASSWORD}" != "" ]; then
    if (! sed --version 1>/dev/null 2>&1); then
        # not a GNU sed
        sed -i '' "s/c1oudc0w/${NISE_PASSWORD}/g" .deploy.yml
    else
        sed -i "s/c1oudc0w/${NISE_PASSWORD}/g" .deploy.yml
    fi
fi


WITH_PRIVILEGE=${WITH_PRIVILEGE:-sudo env PATH=$PATH}

(
    cd nise_bosh
    if [ "" != "$NISE_BOSH_REV" ]; then
        git checkout $NISE_BOSH_REV
    fi
    echo Use nise_bosh of revision: `git rev-list --max-count=1 HEAD` in $0
    bundle install
    # Old spec format
    ${WITH_PRIVILEGE} bundle exec ./bin/nise-bosh -y ../cf-release ../.deploy.yml micro -n ${NISE_IP_ADDRESS}
    # New spec format, keeping the  monit files installed in the previous run
    ${WITH_PRIVILEGE} bundle exec ./bin/nise-bosh --keep-monit-files -y ../cf-release ../.deploy.yml micro_ng -n ${NISE_IP_ADDRESS}
)
