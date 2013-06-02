#!/bin/bash -ex

CF_RELEASE_URL=${CF_RELEASE_URL:-https://github.com/cloudfoundry/cf-release.git}
CF_RELEASE_BRANCH=${CF_RELEASE_BRANCH:-master}

if [ ! -d cf-release ]; then
    git clone --depth 1 -b ${CF_RELEASE_BRANCH} ${CF_RELEASE_URL}
fi

(
    cd cf-release
    ./update
    bosh -n create release --force
)
