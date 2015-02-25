#!/bin/bash -ex

(
    cd nise_bosh
    sudo ./bin/init
    sudo apt-get install -y libmysqlclient-dev libpq-dev
)
