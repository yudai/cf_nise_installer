#!/bin/bash -ex

git submodule update --init --recursive
(
    cd nise_bosh
    if [ "" != "$NISE_BOSH_REV" ]; then
        git checkout $NISE_BOSH_REV
    fi
    echo Use nise_bosh of revision: `git rev-list --max-count=1 HEAD` in $0
)
