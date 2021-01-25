#!/bin/bash

set -euo pipefail

PROJECT=${1}

oc create sa cart -n ${PROJECT}
oc create sa inventory -n ${PROJECT}
oc create sa order -n ${PROJECT}

IMAGES=( cart coolstore-ui inventory catalog order )

for IMAGE in ${IMAGES[@]}; do
    SOURCE_IMAGE="quay.io/mhildenb/lab3-${IMAGE}:initial"
    echo "Importing $SOURCE_IMAGE"
    oc import-image ${IMAGE}:1.0-SNAPSHOT --reference-policy=local --from=${SOURCE_IMAGE} --confirm -n ${PROJECT}
done

# Now potentially trigger Deployments by setting the latest tag in the image stream (which the DeploymentConfigs should be keyed to)
oc tag cart:1.0-SNAPSHOT cart:latest -n $PROJECT
oc tag coolstore-ui:1.0-SNAPSHOT coolstore-ui:latest -n $PROJECT
oc tag inventory:1.0-SNAPSHOT inventory:latest -n $PROJECT
oc tag catalog:1.0-SNAPSHOT catalog:latest -n $PROJECT
oc tag order:1.0-SNAPSHOT order:latest -n $PROJECT