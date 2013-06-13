#!/bin/bash -ex

TARGET=api.${NISE_IP_ADDRESS:-192.168.10.10}.xip.io ./common/register_service_tokens.sh
