#!/bin/bash
exec 1>>cyberark_setup/deploy-labadmin.log 2>&1

export CYBERARK_NAMESPACE_NAME=$1
export CYBERARK_SETUP_DIR=$2

cd cyberark_setup/${CYBERARK_SETUP_DIR}

source ./dap_service_rhpds.config

uname=$(echo user${3})

oc get cm dap-config -n $CYBERARK_NAMESPACE_NAME -o yaml		\
| sed "s/namespace: $CYBERARK_NAMESPACE_NAME/namespace: $uname/"	\
| oc apply -f - -n $uname

cat ./templates/dap-labadmin-manifest.template				\
| sed -e "s#{{ CYBERARK_NAMESPACE_NAME }}#$CYBERARK_NAMESPACE_NAME#g"	\
| sed -e "s#{{ APP_NAMESPACE_NAME }}#$uname#g"				\
| sed -e "s#{{ APP_IMAGE }}#$REGISTRY_LABADMIN_IMAGE#g"			\
| sed -e "s#{{ AUTHENTICATOR_IMAGE }}#$AUTHENTICATOR_IMAGE #g"		\
> ./$uname-dap-labadmin-manifest.yaml
oc apply -f ./$uname-dap-labadmin-manifest.yaml -n $uname
