# using RHEL 7
FROM registry.access.redhat.com/ubi7:7.9

LABEL version = "1.0.0"
LABEL author =  "Glasswall LTD"

ARG RHEL_SUBSCRIPTION_USER
ARG RHEL_SUBSCRIPTION_PWD

COPY harden.sh .
RUN chmod +x harden.sh && bash harden.sh && rm -rf harden.sh
