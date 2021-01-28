#!/bin/bash
set -Eeuo pipefail

declare -r SCRIPT_DIR=$(cd -P $(dirname $0) && pwd)

#declare -r USERS=( $(oc get project | grep -- -che | sed "s/-che.*$//g") )
declare -r USERS=( user2 )
declare -r PASSWORD="r3dh4t1!"

# Where to find the .adoc files for the workshopper pod in the cluster
declare CONTENT_URL_PREFIX="https://raw.githubusercontent.com/hatmarch/cloud-native-workshop-v2m4-guides/ocp-4.5-sa"
declare WORKSHOPS_URLS="_cloud-native-workshop-module4.yml"

echo "Updating lab-guide content"
oc set env -e CONTENT_URL_PREFIX="${CONTENT_URL_PREFIX}" -e WORKSHOPS_URLS="${CONTENT_URL_PREFIX}/${WORKSHOPS_URLS}" dc/guides-m4 -c guides-m4 -n labs-infra
oc rollout status dc/guides-m4 -n labs-infra

for USER in ${USERS[@]}; do
    PROJECT="${USER}-cloudnativeapps"
    echo "Importing imagestreams into ${PROJECT}"
    $SCRIPT_DIR/image-stream-setup.sh ${PROJECT}
    
    echo "Importing kube assets into ${PROJECT}"
    oc process -f $DEMO_HOME/workshop-supplement/lab3.yaml -p PROJECT=${PROJECT} | oc apply -n ${PROJECT} -f -

    echo "Updating workspace for ${USER}"
    $SCRIPT_DIR/update-crw.sh ${USER} ${PASSWORD}
done



 