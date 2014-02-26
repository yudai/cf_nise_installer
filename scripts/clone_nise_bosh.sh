#!/bin/bash -ex

if [ ! "$(ls -A nise_bosh)" ]; then
    git submodule update --init --recursive nise_bosh


    (
        cd nise_bosh

        if [ "" != "$NISE_BOSH_REV" ]; then
            git checkout $NISE_BOSH_REV
        fi

        echo "Using Nise BOSH revision: `git rev-list --max-count=1 HEAD`"
    )
else
    echo "'nise_bosh' directory is not empty. Skipping cloning..."
fi
