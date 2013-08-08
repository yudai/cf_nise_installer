#!/bin/bash -ex

CF_RELEASE_URL=${CF_RELEASE_URL:-https://github.com/cloudfoundry/cf-release.git}
CF_RELEASE_BRANCH=${CF_RELEASE_BRANCH:-ea61ec6f8f}

ruby_version=`rbenv version | cut -f1 -d" "` # overwrite .ruby-version

if [ ! -d cf-release ]; then
    git clone ${CF_RELEASE_URL}
    (
        cd cf-release
        git checkout -f ${CF_RELEASE_BRANCH}
        git submodule foreach --recursive git submodule sync && git submodule update --init --recursive
        RBENV_VERSION=$ruby_version bosh -n create release --force
    )
fi
