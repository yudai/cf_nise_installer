#!/bin/bash -ex

CF_RELEASE_USE_HEAD=${CF_RELEASE_USE_HEAD:-no}

ruby_version=`rbenv version | cut -f1 -d" "` # to overwrite .ruby-version

if [ ! "$(ls -A cf-release)" ]; then
    if [ -z "${CF_RELEASE_URL}" ]; then
        git submodule update --init cf-release
    else
        rmdir cf-release
        git clone ${CF_RELEASE_URL} cf-release
    fi

    (
        cd cf-release

        if [ -n "${CF_RELEASE_BRANCH}" ]; then
            git checkout -f ${CF_RELEASE_BRANCH}
        fi

        if [ $CF_RELEASE_USE_HEAD != "no" ]; then
            # required to compile a gem native extension of CCNG
            sudo apt-get -y install git-core libmysqlclient-dev libpq-dev libsqlite3-dev libxml2-dev libxslt-dev
            gem install rake -v 0.9.2.2 --no-rdoc --no-ri # hack for collector

            git submodule update --init --recursive
            RBENV_VERSION=$ruby_version bundle install
            RBENV_VERSION=$ruby_version bundle exec bosh -n create release --force
        fi
    )
else
    echo "'cf-release' directory is not empty. Skipping cloning..."
fi
