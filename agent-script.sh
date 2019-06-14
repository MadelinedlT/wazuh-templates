#!/bin/bash
apt-get install curl apt-transport-https lsb-release
curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | apt-key add -
echo "deb https://packages.wazuh.com/3.x/apt/ stable main" | tee /etc/apt/sources.list.d/wazuh.list
apt-get update
# insert the manager's internal ip address here
WAZUH_MANAGER_IP="10.130.12.247" apt-get install wazuh-agent
systemctl restart wazuh-agent