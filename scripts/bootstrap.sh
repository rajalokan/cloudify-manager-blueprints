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
if [[ ! -f /tmp/cfymgr_${MANAGER_VERSION}.rpm ]]; then
    wget http://repository.cloudifysource.org/cloudify/${MANAGER_VERSION}/ga-release/cloudify-manager-install-4.4ga.rpm -O /tmp/cfymgr_${MANAGER_VERSION}.rpm
fi
sudo yum install -y /tmp/cfymgr_${MANAGER_VERSION}.rpm

ctx logger info "Installed cloudify-mananger-install package"

PRIVATE_IP=$(hostname -I)
PRIVATE_IP=$(echo "${PRIVATE_IP}" | awk '$1=$1')
PUBLIC_IP=$(curl -s ipinfo.io/ip)
admin_password="admin"
_log "Private IP is: ${PRIVATE_IP}, Public IP is : ${PUBLIC_IP}"

ctx logger info "Using Private IP: ${PRIVATE_IP} and Public IP: ${PUBLIC_IP}"

sudo sed -i "0,/\s*private_ip:.*/s//  private_ip: '${PRIVATE_IP}'/" /etc/cloudify/config.yaml
sudo sed -i "0,/\s*public_ip:.*/s//  public_ip: '${PUBLIC_IP}'/" /etc/cloudify/config.yaml
sudo sed -i '0,/\s*skip_installation:.*/s//    skip_installation: false/' /etc/cloudify/config.yaml
sudo sed -i '0,/\s*skip_sanity:.*/s//  skip_sanity: true/' /etc/cloudify/config.yaml
sudo sed -i "0,/\s*networks:.*/s//  networks: {default: ${PRIVATE_IP}, external: ${PUBLIC_IP}}/" /etc/cloudify/config.yaml
sudo sed -i "0,/\s*admin_password:.*/s//    admin_password: \"${admin_password}\"/" /etc/cloudify/config.yaml

ctx logger info "Installing Manager"
cfy_manager install
ctx logger info "Manager is successfully installed"
