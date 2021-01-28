#!/bin/bash
set -euo pipefail

declare USER=${1}
declare PASSWORD=${2}

echo "In $0 for ${USER}"
TOKEN=$(curl -X POST -s -d "username=${USER}&password=${PASSWORD}&grant_type=password&client_id=admin-cli" \
    https://$(oc get route keycloak -n labs-infra -o jsonpath='{.spec.host}')/auth/realms/codeready/protocol/openid-connect/token | jq -r '.access_token')

# Stop and delete any existing workspace
WORKSPACE_ID=$(crwctl workspace:list -n labs-infra --access-token=${TOKEN} 2>/dev/null | grep ${USER}-workspace | awk '{ print $1 }')
if [[ -z ${WORKSPACE_ID} ]]; then
    echo "No existing workspace for ${USER}"
else
    # this will sometimes fail since workspaces may be stopped already
    echo "Attempting to stop workspace ${WORKSPACE_ID} for user ${USER}"
    crwctl workspace:stop -n labs-infra --access-token=${TOKEN} ${WORKSPACE_ID} 2>/dev/null || true

    # if we fail to delete an existing workspace, then this is an error that we need to pay attention to
    crwctl workspace:delete -n labs-infra --access-token=${TOKEN} ${WORKSPACE_ID}
fi

sed "s/%USER%/${USER}/g" ${DEMO_HOME}/Devfile_Template.yaml > /tmp/Devfile.yaml
crwctl workspace:create -f /tmp/Devfile.yaml --access-token=${TOKEN} -n labs-infra --start