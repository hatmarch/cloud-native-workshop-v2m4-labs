FROM quay.io/mhildenb/kn-demo-base:latest

USER root

RUN curl -sSL "https://github.com/buildpacks/pack/releases/download/v0.15.1/pack-v0.15.1-linux.tgz" | tar -C /usr/local/bin/ --no-same-owner -xzv pack

# Add crwctl for updating user workspaces
RUN wget -qO- https://mwh-demo-assets.s3-ap-southeast-2.amazonaws.com/codeready-workspaces-2.5.1-GA-crwctl-linux-x64.tar.gz | tar -zxvf - -C /opt
ENV PATH ${PATH}:/opt/crwctl/bin

USER jboss

# Default DEMO_HOME directory
ENV DEMO_HOME /workspaces/cloud-native-workshop-v2m4-labs

