#!/bin/sh -ex

cf target ${TARGET}
cf login --password micr0@micr0 micro@vcap.me | true

for service in postgresql mysql; do
    cf create-service-auth-token --provider core --token token --label ${service} | true
done
