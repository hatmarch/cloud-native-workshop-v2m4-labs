#!/bin/bash
set -euo pipefail

declare -r USERS=( $(oc get project | grep -- -che | sed "s/-che.*$//g") )
declare -r PASSWORD="r3dh4t1!"

for USER in ${USERS[@]}; do
    echo "Updating workspace for ${USER}"
    TOKEN=$(curl -X POST -s -d "username=${USER}&password=${PASSWORD}&grant_type=password&client_id=admin-cli" \
        https://$(oc get route keycloak -n labs-infra -o jsonpath='{.spec.host}')/auth/realms/codeready/protocol/openid-connect/token | jq -r '.access_token')
    WORKSPACE_ID=$(crwctl workspace:list -n labs-infra --access-token=${TOKEN} | grep ${USER}-workspace | awk '{ print $1 }')
    crwctl workspace:stop -n labs-infra --access-token=${TOKEN} ${WORKSPACE_ID}
    crwctl workspace:delete -n labs-infra --access-token=${TOKEN} ${WORKSPACE_ID}
    sed "s/%USER%/${USER}/g" ${DEMO_HOME}/Devfile_Template.yaml > /tmp/Devfile.yaml
    crwctl workspace:create -f /tmp/Devfile.yaml --access-token=${TOKEN} -n labs-infra --start
done