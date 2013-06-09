#!/bin/sh -ex

cf target api.${BRIDGE_IP_ADDRESS:=${CURRENT_IP:=192.168.10.10}}.xip.io
cf login --password micr0@micr0 micro@vcap.me | true

for service in postgresql mysql; do
    cf create-service-auth-token --provider core --token token --label ${service} | true
done
