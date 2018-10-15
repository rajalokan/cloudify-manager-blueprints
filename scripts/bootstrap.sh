#! /bin/bash -e

ctx logger info "Bootstrapping manager node"
# Install basic packages
sudo yum install -y wget vim git epel-release
# Source sclib
[[ -f /tmp/sclib.sh ]] \
    || wget -q https://raw.githubusercontent.com/rajalokan/okanstack/master/sclib.sh -O /tmp/sclib.sh
source /tmp/sclib.sh
# Install Manager
MANAGER_VERSION="4.4.0"
wget http://repository.cloudifysource.org/cloudify/${MANAGER_VERSION}/ga-release/cloudify-manager-install-4.4ga.rpm -O /tmp/cfymgr_${MANAGER_VERSION}.rpm
sudo yum install -y /tmp/cfymgr_${MANAGER_VERSION}.rpm

PRIVATE_IP=
PUBLIC_IP=

sudo sed -i "0,/\s*private_ip:.*/s//  private_ip: '${PRIVATE_IP}'/" /etc/cloudify/config.yaml
sudo sed -i "0,/\s*public_ip:.*/s//  public_ip: '${PUBLIC_IP}'/" /etc/cloudify/config.yaml
sudo sed -i '0,/\s*skip_installation:.*/s//    skip_installation: false/' /etc/cloudify/config.yaml
sudo sed -i "0,/\s*networks:.*/s//  networks: {default: ${PRIVATE_IP}, external: ${PUBLIC_IP}}/" /etc/cloudify/config.yaml

cfy_manager install
