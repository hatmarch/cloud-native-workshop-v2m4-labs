#!/bin/bash

declare -A IMAGE_MAP=( [cart]="user1-cloudnativeapps/cart@sha256:bf1035537aa903360e65379f1a333343a4fff6a87e429ee5c73a2f6e135a0565" \
    [catalog]="user1-cloudnativeapps/catalog@sha256:7e82b81139ebddbbf9bf1eb84c4a43b83c8b319e4d8e46f84fcb484f93a1c213" \
    [coolstore-ui]="user1-cloudnativeapps/coolstore-ui@sha256:aacd05495b8e2046e80440ee532c1723757c9fce23553c64577cf54d7fd87ae9" \
    [inventory]="user1-cloudnativeapps/inventory@sha256:0824832945a85e360ffab57f737969dc9ed85f9bd629dc84b7591d4324a95664" \
    [order]="user1-cloudnativeapps/order@sha256:85a7b0b6030c090dcab50b8b732518135d4a5da9ca8ca7fe19de7d15e224c798" )

#declare -r REMOTE_CRED="mhildenb:q5[TNNMDJ'b0"
declare -r REMOTE_CRED="mhildenb+skopeo:AFRVK76TLUN0ZU095U1L2ARGITSYENZ6P5TIFKNX9KDPPTLDFY9CRE5SOZPXW6EJ"
declare -r SRC_CRED="$(oc whoami):$(oc whoami -t)"
declare -r SRC_REPO="localhost:5000"
declare -r REMOTE_REPO="quay.io/mhildenb"


for IMAGE in "${!IMAGE_MAP[@]}"; do 
    echo $IMAGE --- ${IMAGE_MAP[$IMAGE]}; 
    DIGEST=${IMAGE_MAP[$IMAGE]}

    #skopeo copy --src-creds ${SRC_CRED} --src-tls-verify=false docker://${SRC_REPO}/${DIGEST} docker://${REMOTE_REPO}lab3-${IMAGE}:initial

    skopeo copy --src-creds ${SRC_CRED} --src-tls-verify=false --dest-creds "${REMOTE_CRED}" docker://${SRC_REPO}/${DIGEST} docker://${REMOTE_REPO}/lab3-${IMAGE}:initial

done


# skopeo copy --src-creds ${SRC_CREDS} --src-tls-verify=false --dest-creds ${REMOTE_CREDS} \
#     docker://${SRC_REPO}/user1-cloudnativeapps/cart docker://${REMOTE_REPO}lab3-cart:initial

# user1-cloudnativeapps/cart