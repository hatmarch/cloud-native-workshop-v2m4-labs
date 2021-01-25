#!/bin/bash
set -Eeuo pipefail

declare -r SCRIPT_DIR=$(cd -P $(dirname $0) && pwd)

declare -r USERS=( $(oc get project | grep -- -che | sed "s/-che.*$//g") )
declare -r PASSWORD="r3dh4t1!"

for USER in ${USERS[@]}; do
    PROJECT="${USER}-cloudnativeapps"
    echo "Importing imagestreams into ${PROJECT}"
    $SCRIPT_DIR/image-stream-setup.sh ${PROJECT}
    
    echo "Importing kube assets into ${PROJECT}"
    oc process -f $DEMO_HOME/workshop-supplement/lab3.yaml -p PROJECT=${PROJECT} | oc apply -n ${PROJECT} -f -

    echo "Updating workspace for ${USER}"
    $SCRIPT_DIR/update-crw.sh ${USER} ${PASSWORD}
done