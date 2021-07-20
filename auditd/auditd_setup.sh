#! /bin/bash

###################################
## AUTHOR: SACHA ROUSSAKIS-NOTTER #
###################################

##############
## VARIABLES #
##############

workplaceID= "60d75d70-760a-4c85-9fe8-2db198997a00"
primaryKey= "Wl5Ui4ema4HLCG34PawFMjvIK9n7yRmexby01DDs64eVAm1reAE8ElCtlEIBc4P0gllfiY9OkzoLlUxHMzL+aA=="

# Updating Azure Virtual Ubuntu Machine
sudo apt-get update -y
sudo apt upgrade -y
sudo apt autoremove --assume-yes
# Installing auditd
sudo apt install -y auditd

####################
## AUDITD INSTALL ##
####################

# Downloading and installing the MITRE attack rules
wget -q -P /etc/audit/rules.d mitre_attack.rules https://raw.githubusercontent.com/DFW1N/shell-scripts/main/mitre_attack.rules

# Restarting auditd service
service auditd restart

# Over writing systemd-user file with curl command
curl https://raw.githubusercontent.com/DFW1N/shell-scripts/main/auditd/systemd-user > /etc/pam.d/systemd-user

# Over writing sshd file with curl command
curl https://raw.githubusercontent.com/DFW1N/shell-scripts/main/auditd/sshd > /etc/pam.d/sshd

# Download Linux OMS Agent (Change /home/adminuser to your linux {Username})
wget -P ~/ omsagent-1.13.35-0.universal.x64.sh https://github.com/microsoft/OMS-Agent-for-Linux/releases/download/OMSAgent_v1.13.35-0/omsagent-1.13.35-0.universal.x64.sh
# Install OMS Agent (Change -w Workspace and -s Shared key)
sudo sh ./omsagent-*.universal.x64.sh --upgrade -w $workplaceID -s $primaryKey
# Copy the omsagent .conf file to the omsagent workspace
sudo cp /etc/opt/microsoft/omsagent/sysconf/omsagent.d/auditlog.conf /etc/opt/microsoft/omsagent/$workplaceID/conf/omsagent.d/
# Restart the OMS Agent
sudo /opt/microsoft/omsagent/bin/service_control restart
# Check OMS Agent log for Agent Restart
sudo tail /var/opt/microsoft/omsagent/$workplaceID/log/omsagent.log
