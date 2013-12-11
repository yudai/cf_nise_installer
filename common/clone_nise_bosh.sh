#!/bin/bash -ex

if [ ! -d nise_bosh ]; then
    git clone https://github.com/nttlabs/nise_bosh.git
fi
(
    cd nise_bosh
    if [ "" != "$NISE_BOSH_REV" ]; then
        git checkout $NISE_BOSH_REV
    fi
    echo Use nise_bosh of revision: `git rev-list --max-count=1 HEAD` in $0
)
