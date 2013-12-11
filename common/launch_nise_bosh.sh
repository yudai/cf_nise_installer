#!/bin/bash -ex

CF_RELEASE_USE_HEAD=${CF_RELEASE_USE_HEAD:-no}

cd nise_bosh
bundle install
release_version=`bundle exec ./bin/nise-bosh -w -m ../cf-release`
base_release_version=`echo $release_version | cut -f 1 -d '-' | cut -f 1 -d '.'`
cd ..

cd manifests
for version in `ls * | sort  | cut -f 1 -d '.'`; do
    if [ $version -lt $base_release_version ]; then
        selected_manifest=$version
        break
    fi
done
cd ..

if [ $CF_RELEASE_USE_HEAD != "no" ]; then
    selected_manifest=head
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
