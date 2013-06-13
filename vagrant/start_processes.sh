#!/bin/sh -ex

(
    cd cf-release
    vagrant ssh -c "`cat ../common/start_processes.sh`"
)
