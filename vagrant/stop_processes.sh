#!/bin/sh -ex

(
    cd cf-release
    vagrant ssh -c "`cat ../common/stop_processes.sh`"
)

