#! /bin/bash

###################################
## WRITTEN BY: SACHA ROUSSAKIS-NOTTER #
###################################

##############
## VARIABLES #
##############
             
# Both values can be found in " Log Analytics Workspace > Workspace Name > Agents Management > Linux Servers > Workspace ID & Primary Key "
workplaceID="00000000-0000-0000-0000-000000000000" # <------ Change to your Workspace ID
primaryKey="0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" # <------ Change to your Workspace Primary Key
linuxuser="adminuser"  # <------ Change to your Linux VM administrator user

# Updating Azure Virtual Ubuntu Machine
sudo apt-get update -y
sudo apt upgrade -y
sudo apt autoremove --assume-yes

####################
## AUDITD INSTALL ##
####################

# Installing auditd
sudo apt install -y auditd

# Downloading and installing the MITRE attack rules
wget -q -P /etc/audit/rules.d mitre_attack.rules https://raw.githubusercontent.com/DFW1N/shell-scripts/main/mitre_attack.rules

# Restarting auditd service
sudo service auditd restart

# Over writing systemd-user file with curl command
sudo curl https://raw.githubusercontent.com/DFW1N/shell-scripts/main/auditd/systemd-user > /etc/pam.d/systemd-user

# Over writing sshd file with curl command
sudo curl https://raw.githubusercontent.com/DFW1N/shell-scripts/main/auditd/sshd > /etc/pam.d/sshd

# Download Linux OMS Agent
sudo wget -q -P /home/$linxuser/ https://github.com/microsoft/OMS-Agent-for-Linux/releases/download/OMSAgent_v1.13.35-0/omsagent-1.13.35-0.universal.x64.sh

# Giving the downloaded shell script full permissions
sudo chmod +x omsagent-1.13.35-0.universal.x64.sh
# Install OMS Agent
sudo sh ./omsagent-*.universal.x64.sh --upgrade -w $workplaceID -s $primaryKey
# Copy the omsagent .conf file to the omsagent workspace
sudo cp /etc/opt/microsoft/omsagent/sysconf/omsagent.d/auditlog.conf /etc/opt/microsoft/omsagent/$workplaceID/conf/omsagent.d/
# Restart the OMS Agent
sudo /opt/microsoft/omsagent/bin/service_control restart
# Giving the logs 8 seconds to generate before checking OMS Agent Log
sleep 8
# Check OMS Agent log for Agent Restart
sudo tail /var/opt/microsoft/omsagent/$workplaceID/log/omsagent.log
