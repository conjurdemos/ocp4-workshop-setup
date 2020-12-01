#!/bin/bash

export CYBERARK_NAMESPACE_NAME=$1
export CYBERARK_SETUP_DIR=$2

source cyberark_setup/${CYBERARK_SETUP_DIR}/dap_service_rhpds.config

echo $CONJUR_APPLIANCE_URL