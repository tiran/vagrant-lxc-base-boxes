#!/bin/bash
set -e

source common/ui.sh
source common/utils.sh

info 'Installing extra packages and upgrading'

debug 'Bringing container up'
utils.lxc.start

# Sleep for a bit so that the container can get an IP
SECS=20
log "Sleeping for $SECS seconds..."
sleep $SECS

# TODO: Support for appending to this list from outside
PACKAGES=(vim curl wget man-db bash-completion ca-certificates sudo openssh-server)

# extra stuff for Dogtag PKI
EXTRA_PACKAGES=( \
    389-ds-base httpd jackson java-headless jss ldapjdk libselinux-python \
    nss nss-tools nuxwdog openldap-clients policycoreutils-python python-ldap \
    python-lxml python-requests python-six resteasy-client rng-tools \
    selinux-policy selinux-policy-targeted tomcat xalan-j2 xerces-j2 \
    yum-utils)

utils.lxc.attach yum update -y
utils.lxc.attach yum install ${PACKAGES[*]} -y
utils.lxc.attach yum install ${EXTRA_PACKAGES[*]} -y
utils.lxc.attach yum clean all

