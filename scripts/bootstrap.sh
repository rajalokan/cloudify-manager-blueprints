#! /bin/bash -e

ctx logger info "Bootstrapping playbox"
MANAGER_VERSION="4.4.0"
wget http://repository.cloudifysource.org/cloudify/${MANAGER_VERSION}/ga-release/cloudify-manager-install-4.4ga.rpm -O /tmp/cfymgr_${MANAGER_VERSION}.rpm
sudo yum install -y /tmp/cfymgr_${MANAGER_VERSION}.rpm
