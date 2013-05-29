#!/bin/bash -ex

if [ ! -d cf-release ]; then
    git clone --depth 1 https://github.com/cloudfoundry/cf-release.git
fi

(
    cd cf-release
    ./update
    bosh -n create release --force
)
