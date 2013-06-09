#!/bin/bash -ex

CF_RELEASE_URL=${CF_RELEASE_URL:-https://github.com/cloudfoundry/cf-release.git}
CF_RELEASE_BRANCH=${CF_RELEASE_BRANCH:-master}

if [ ! -d cf-release ]; then
    git clone ${CF_RELEASE_URL}
    (
        cd cf-release
        git checkout ${CF_RELEASE_BRANCH}
    )
fi

(
    cd cf-release
    git submodule foreach --recursive git submodule sync && git submodule update --init --recursive
    bosh -n create release --force
)
