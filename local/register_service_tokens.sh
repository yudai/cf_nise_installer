#!/bin/bash -ex

NISE_IP_ADDRESS=${NISE_IP_ADDRESS:-`ip addr | grep 'inet .*global' | cut -f 6 -d ' ' | cut -f1 -d '/' | head -n 1`}

TARGET=api.${NISE_IP_ADDRESS}.xip.io ./common/register_service_tokens.sh
