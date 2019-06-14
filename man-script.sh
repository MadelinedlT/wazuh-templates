#!/bin/bash
apt-get update
apt-get install curl apt-transport-https lsb-release
curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | apt-key add -
echo "deb https://packages.wazuh.com/3.x/apt/ stable main" | tee -a /etc/apt/sources.list.d/wazuh.list
apt-get update

#Install Wazuh-Manager
apt-get install wazuh-manager
systemctl status wazuh-manager

#Install Wazuh-API
curl -sL https://deb.nodesource.com/setup_8.x | bash -
apt-get install wazuh-api -y
systemctl status wazuh-api

#Install Filebeat
apt-get install curl apt-transport-https
curl -s https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee /etc/apt/sources.list.d/elastic-7.x.list
apt-get update
apt-get install filebeat=7.1.1
curl -so /etc/filebeat/filebeat.yml https://raw.githubusercontent.com/wazuh/wazuh/v3.9.1/extensions/filebeat/7.x/filebeat.yml
curl -so /etc/filebeat/wazuh-template.json https://raw.githubusercontent.com/wazuh/wazuh/v3.9.1/extensions/elasticsearch/7.x/wazuh-template.json
sed -i -e 's/YOUR_ELASTIC_SERVER_IP/localhost/g' /etc/filebeat/filebeat.yml
systemctl daemon-reload
systemctl enable filebeat.service
systemctl start filebeat.service

#Install Elastic Stack
apt-get install curl apt-transport-https
curl -s https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee /etc/apt/sources.list.d/elastic-7.x.list
apt-get update
apt-get install elasticsearch=7.1.1
systemctl daemon-reload
systemctl enable elasticsearch.service
systemctl start elasticsearch.service

#Install Kibana
apt-get install kibana=7.1.1
sudo -u kibana /usr/share/kibana/bin/kibana-plugin install https://packages.wazuh.com/wazuhapp/wazuhapp-3.9.1_7.1.1.zip
sed -i -e 's/#server.host: "localhost"/server.host: "0.0.0.0"/g' /etc/kibana/kibana.yml
systemctl daemon-reload
systemctl enable kibana.service
systemctl start kibana.service