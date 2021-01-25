#!/bin/bash
set -euo pipefail

declare USER=${1}
declare PASSWORD=${2}

echo "In $0 for ${USER}"
TOKEN=$(curl -X POST -s -d "username=${USER}&password=${PASSWORD}&grant_type=password&client_id=admin-cli" \
    https://$(oc get route keycloak -n labs-infra -o jsonpath='{.spec.host}')/auth/realms/codeready/protocol/openid-connect/token | jq -r '.access_token')
WORKSPACE_ID=$(crwctl workspace:list -n labs-infra --access-token=${TOKEN} | grep ${USER}-workspace | awk '{ print $1 }')
crwctl workspace:stop -n labs-infra --access-token=${TOKEN} ${WORKSPACE_ID}
crwctl workspace:delete -n labs-infra --access-token=${TOKEN} ${WORKSPACE_ID}
sed "s/%USER%/${USER}/g" ${DEMO_HOME}/Devfile_Template.yaml > /tmp/Devfile.yaml
crwctl workspace:create -f /tmp/Devfile.yaml --access-token=${TOKEN} -n labs-infra --start