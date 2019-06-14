# Wazuh-Manager: Register Agent
#
# this is a script to register the
# agent and then store the agent key
# in a text file: key.txt and store the
# agent id in a text file: id.txt
#
# Parameters:
#       - this script needs 2 parameters
#               1. name of agent
#               2. agent's internal ip address

# check for ensuring 2 variables passed
if [ $# -ne 2 ]
then
        echo "usage: need two arguments"
        exit -1
fi

# regex patterns
patternName="^[a-zA-Z0-9]{2,32}$"
patternIP="^[0-2]{0,1}[0-9]{0,2}\.[0-2]{0,1}[0-9]{0,2}\.[0-2]{0,1}[0-9]{0,2}\.[0-2]{0,1}[0-9]{0,2}$"
patternIPRange="^[0-2]{0,1}[0-9]{0,2}\.[0-2]{0,1}[0-9]{0,2}\.[0-2]{0,1}[0-9]{0,2}\.[0-2]{0,1}[0-9]{0,2}/[0-9][0-9]$"
patternAny="^any$"

# check for valid ip address of $2
if  [[ ! $2 =~ $patternIP ]] && [[ ! $2 =~ $patternIPRange ]] &&  [[ ! $2 =~ $patternAny ]]
then
        echo "usage: second parameter must be an ip address, an ip range, or 'any'"
        exit -1
fi

# check for valid agent name of $1
if ! [[ $1 =~ $patternName ]]
then
        echo "usage: agent name can can be of length 2-32 and can only be alphanumberic"
        exit -1
fi

# ensure that agent name does not exist by listing all the agents
/var/ossec/bin/manage_agents -l > allagents.txt

# count the number of agents that match the ip address
count=$(grep -c $2 allagents.txt)

if [[ $count -ge 1 ]] && [[ $2 =~ $patternIP ]]
then
        echo "usage: this ip address is already registered to an agent"
        exit -1
fi