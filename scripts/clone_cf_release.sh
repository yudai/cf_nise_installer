#!/bin/bash -ex

CF_RELEASE_USE_HEAD=${CF_RELEASE_USE_HEAD:-no}

ruby_version=`rbenv version | cut -f1 -d" "` # to overwrite .ruby-version

if [ ! -d cf-release ]; then
    if [ -z "${CF_RELEASE_URL}" ]; then
        git submodule update --init cf-release
    else
        git clone ${CF_RELEASE_URL} cf-release
    fi

    (
        cd cf-release

        if [ -z "${CF_RELEASE_BRANCH}" ]; then
            git checkout -f ${CF_RELEASE_BRANCH}
        fi

        if [ $CF_RELEASE_USE_HEAD != "no" ]; then
            git submodule update --init --recursive
            RBENV_VERSION=$ruby_version bundle install
            RBENV_VERSION=$ruby_version bundle exec bosh -n create release --force
        fi
    )
else
    echo "'cf-release' directory exists. Skipping cloning..."
fi
