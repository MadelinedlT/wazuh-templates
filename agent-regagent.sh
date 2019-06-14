#!/bin/bash
# Wazuh-Agent: Register Agent
#
# this is a script to register the
# agent
#
# Parameters:
#       - this script needs access to the key file

# register the agent
id="$(cat key.txt)"
/var/ossec/bin/manage_agents -i $id <<'EOF'
y
EOF