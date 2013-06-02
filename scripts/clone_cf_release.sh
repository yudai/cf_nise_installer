#!/bin/bash -ex

CF_RELEASE_BRANCH=${CF_RELEASE_BRANCH:-master}

if [ ! -d cf-release ]; then
    git clone --depth 1 https://github.com/cloudfoundry/cf-release.git
fi

(
    cd cf-release
    git checkout -b ${CF_RELEASE_BRANCH}
    ./update
    bosh -n create release --force
)
